import 'package:expense/features/auth/data/auth_repository_impl.dart';
import 'package:expense/features/auth/data/firebase_auth_datasource.dart';
import 'package:expense/features/auth/domain/auth_repository.dart';
import 'package:expense/features/auth/domain/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(FirebaseAuthDatasource());
});

final authStateProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authStateProvider).valueOrNull != null;
});

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});

class AuthController extends StateNotifier<AsyncValue<void>> {

  AuthController(this._repository) : super(const AsyncValue.data(null));
  final AuthRepository _repository;

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await _repository.signInWithGoogle();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.signOut();
      state = const AsyncValue.data(null);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}