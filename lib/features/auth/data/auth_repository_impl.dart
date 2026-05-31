import '../domain/auth_repository.dart';
import '../domain/models/user_model.dart';
import 'firebase_auth_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDatasource _datasource;

  AuthRepositoryImpl(this._datasource);

  @override
  Stream<UserModel?> get authStateChanges => _datasource.authStateChanges;

  @override
  Future<UserModel?> signInWithGoogle() => _datasource.signInWithGoogle();

  @override
  Future<void> signOut() => _datasource.signOut();
}
