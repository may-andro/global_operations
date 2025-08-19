abstract class UserRepository {
  /// Creates a new user account with email and password
  Future<String> createAccount({
    required String email,
    required String password,
  });

  /// Deletes the current user account with reauthentication
  Future<void> deleteAccount({required String email, required String password});

  /// Updates the password for the currently signed-in user
  Future<void> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });

  /// Sends a password reset email to the user
  Future<void> resetPassword({required String email});

  /// Completes the password reset process using the code from the email
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  });

  /// Verifies a password reset code is valid without resetting the password
  Future<String> verifyPasswordResetCode({required String code});
}
