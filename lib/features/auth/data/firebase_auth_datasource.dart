import 'dart:async';
import 'package:expense/features/auth/domain/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final StreamController<UserModel?> _mockUserStreamController = StreamController<UserModel?>.broadcast();
  UserModel? _currentMockUser;

  Stream<UserModel?> get authStateChanges {
    final controller = StreamController<UserModel?>();
    StreamSubscription<User?>? firebaseSub;
    StreamSubscription<UserModel?>? mockSub;

    void updateState(UserModel? user) {
      if (!controller.isClosed) {
        controller.add(user);
      }
    }

    firebaseSub = _auth.authStateChanges().listen((user) {
      if (_currentMockUser == null) {
        updateState(user != null
            ? UserModel(
                id: user.uid,
                email: user.email ?? '',
                displayName: user.displayName ?? 'User',
                photoUrl: user.photoURL,
              )
            : null);
      }
    });

    mockSub = _mockUserStreamController.stream.listen((user) {
      _currentMockUser = user;
      if (user != null) {
        updateState(user);
      } else {
        final firebaseUser = _auth.currentUser;
        updateState(firebaseUser != null
            ? UserModel(
                id: firebaseUser.uid,
                email: firebaseUser.email ?? '',
                displayName: firebaseUser.displayName ?? 'User',
                photoUrl: firebaseUser.photoURL,
              )
            : null);
      }
    });

    controller
      ..onListen = () {
        if (_currentMockUser != null) {
          updateState(_currentMockUser);
        } else {
          final firebaseUser = _auth.currentUser;
          updateState(firebaseUser != null
              ? UserModel(
                  id: firebaseUser.uid,
                  email: firebaseUser.email ?? '',
                  displayName: firebaseUser.displayName ?? 'User',
                  photoUrl: firebaseUser.photoURL,
                )
              : null);
        }
      }
      ..onCancel = () {
        firebaseSub?.cancel();
        mockSub?.cancel();
      };

    return controller.stream;
  }

  Future<UserModel?> signInWithMock() async {
    const mockUser = UserModel(
      id: 'mock_user_alex',
      email: 'alex.spencer@example.com',
      displayName: 'Alex Spencer',
      photoUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100&auto=format&fit=crop&q=80',
    );
    _currentMockUser = mockUser;
    _mockUserStreamController.add(mockUser);
    return mockUser;
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; // user canceled

      final googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(
        credential,
      );

      final user = userCredential.user;
      if (user != null) {
        return UserModel(
          id: user.uid,
          email: user.email ?? '',
          displayName: user.displayName ?? 'User',
          photoUrl: user.photoURL,
        );
      }
    } catch (e) {
      throw Exception('Failed to sign in with Google: $e');
    }
    return null;
  }

  Future<void> signOut() async {
    _currentMockUser = null;
    _mockUserStreamController.add(null);
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
