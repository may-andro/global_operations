import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._authController);

  final FbAuthController _authController;

  @override
  Future<String> createAccount({
    required String email,
    required String password,
  }) async {
    return await _authController.createAccount(
      email: email,
      password: password,
    );
  }

  @override
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    await _authController.deleteAccount(email: email, password: password);
  }

  @override
  Future<void> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    await _authController.updatePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    await _authController.resetPassword(email: email);
  }

  @override
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    await _authController.confirmPasswordReset(
      code: code,
      newPassword: newPassword,
    );
  }

  @override
  Future<String> verifyPasswordResetCode({required String code}) async {
    return await _authController.verifyPasswordResetCode(code: code);
  }
}
