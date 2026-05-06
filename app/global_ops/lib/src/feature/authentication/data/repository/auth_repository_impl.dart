import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._authController);

  final FbAuthController _authController;

  @override
  UserProfileEntity? get currentUser {
    final user = _authController.currentUser;

    if (user == null) return null;

    final email = user.email;
    if (email == null) return null;

    return UserProfileEntity(id: user.uid, email: email);
  }

  @override
  bool get isSignedIn => _authController.isSignedIn;

  @override
  Stream<UserProfileEntity?> get authStateChanges {
    return _authController.authStateChanges.map((user) {
      if (user == null) return null;

      final email = user.email;
      if (email == null) return null;

      return UserProfileEntity(id: user.uid, email: email);
    });
  }

  @override
  Future<String> login({
    required String email,
    required String password,
  }) async {
    return await _authController.signIn(email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await _authController.signOut();
  }
}
