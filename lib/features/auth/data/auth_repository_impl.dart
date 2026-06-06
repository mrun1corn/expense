import 'package:expense/features/auth/data/firebase_auth_datasource.dart';
import 'package:expense/features/auth/domain/auth_repository.dart';
import 'package:expense/features/auth/domain/models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {

  AuthRepositoryImpl(this._datasource);
  final FirebaseAuthDatasource _datasource;

  @override
  Stream<UserModel?> get authStateChanges => _datasource.authStateChanges;

  @override
  Future<UserModel?> signInWithGoogle() => _datasource.signInWithGoogle();

  @override
  Future<UserModel?> signInWithMock() => _datasource.signInWithMock();

  @override
  Future<void> signOut() => _datasource.signOut();
}
