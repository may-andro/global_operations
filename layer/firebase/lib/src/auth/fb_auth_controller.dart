import 'package:firebase_auth/firebase_auth.dart';

/// Base sealed class for authentication exceptions
sealed class AuthException implements Exception {
  const AuthException(this.message);

  /// Factory constructor to create AuthException from FirebaseAuthException
  factory AuthException.fromFirebaseAuth(FirebaseAuthException e) {
    return switch (e.code) {
      'user-not-found' => const UserNotFoundException(),
      'wrong-password' => const WrongPasswordException(),
      'invalid-email' => const InvalidEmailException(),
      'email-already-in-use' => const EmailAlreadyInUseException(),
      'weak-password' => const WeakPasswordException(),
      'too-many-requests' => const TooManyRequestsException(),
      'requires-recent-login' => const RequiresRecentLoginException(),
      'user-disabled' => const UserDisabledException(),
      'operation-not-allowed' => const OperationNotAllowedException(),
      'invalid-credential' => const InvalidCredentialException(),
      'credential-already-in-use' => const CredentialAlreadyInUseException(),
      'network-request-failed' => const NetworkRequestFailedException(),
      'invalid-action-code' => const InvalidPasswordResetCodeException(),
      'expired-action-code' => const ExpiredPasswordResetCodeException(),
      _ => UnknownAuthException('Firebase error: ${e.message}'),
    };
  }

  /// Factory constructor for general exceptions
  factory AuthException.fromException(Object e) {
    if (e is FirebaseAuthException) {
      return AuthException.fromFirebaseAuth(e);
    }
    return UnknownAuthException('An unexpected error occurred: $e');
  }

  final String message;

  @override
  String toString() => message;
}

/// User not found exception
final class UserNotFoundException extends AuthException {
  const UserNotFoundException()
    : super('No account found with this email address.');
}

/// Wrong password exception
final class WrongPasswordException extends AuthException {
  const WrongPasswordException()
    : super('Incorrect password. Please try again.');
}

/// Invalid email exception
final class InvalidEmailException extends AuthException {
  const InvalidEmailException() : super('Please enter a valid email address.');
}

/// Email already in use exception
final class EmailAlreadyInUseException extends AuthException {
  const EmailAlreadyInUseException()
    : super('An account with this email already exists.');
}

/// Weak password exception
final class WeakPasswordException extends AuthException {
  const WeakPasswordException()
    : super('Password is too weak. Please choose a stronger password.');
}

/// Too many requests exception
final class TooManyRequestsException extends AuthException {
  const TooManyRequestsException()
    : super('Too many failed attempts. Please try again later.');
}

/// Requires recent login exception
final class RequiresRecentLoginException extends AuthException {
  const RequiresRecentLoginException()
    : super(
        'This action requires recent authentication. Please sign in again.',
      );
}

/// User disabled exception
final class UserDisabledException extends AuthException {
  const UserDisabledException() : super('This account has been disabled.');
}

/// Operation not allowed exception
final class OperationNotAllowedException extends AuthException {
  const OperationNotAllowedException()
    : super('This sign-in method is not enabled.');
}

/// Invalid credential exception
final class InvalidCredentialException extends AuthException {
  const InvalidCredentialException()
    : super('The provided credentials are invalid.');
}

/// Credential already in use exception
final class CredentialAlreadyInUseException extends AuthException {
  const CredentialAlreadyInUseException()
    : super('This credential is already associated with another account.');
}

/// Network request failed exception
final class NetworkRequestFailedException extends AuthException {
  const NetworkRequestFailedException()
    : super('Network error. Please check your connection and try again.');
}

/// Invalid password reset code exception
final class InvalidPasswordResetCodeException extends AuthException {
  const InvalidPasswordResetCodeException()
    : super('The password reset code is invalid or has expired.');
}

/// Expired password reset code exception
final class ExpiredPasswordResetCodeException extends AuthException {
  const ExpiredPasswordResetCodeException()
    : super('The password reset code has expired. Please request a new one.');
}

/// No current user exception
final class NoCurrentUserException extends AuthException {
  const NoCurrentUserException() : super('No user is currently signed in.');
}

/// User creation failed exception
final class UserCreationFailedException extends AuthException {
  const UserCreationFailedException()
    : super('Account creation failed. Please try again.');
}

/// Sign in failed exception
final class SignInFailedException extends AuthException {
  const SignInFailedException() : super('Sign in failed. Please try again.');
}

/// Unknown authentication exception
final class UnknownAuthException extends AuthException {
  const UnknownAuthException(super.message);
}

class FbAuthController {
  FbAuthController(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  /// Gets the current user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Checks if a user is currently signed in
  bool get isSignedIn => _firebaseAuth.currentUser != null;

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Creates a new user account with email and password
  Future<String> createAccount({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user == null) {
        throw const UserCreationFailedException();
      }

      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException.fromException(e);
    }
  }

  /// Deletes the current user account with reauthentication
  /// Use this when you need to ensure the user is recently authenticated
  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const NoCurrentUserException();
      }

      // Reauthenticate the user before deletion
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // Now delete the account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException.fromException(e);
    }
  }

  /// Signs in a user with email and password
  Future<String> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = userCredential.user;

      if (user == null) {
        throw const SignInFailedException();
      }

      return user.uid;
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException.fromException(e);
    }
  }

  /// Signs out the current user
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      throw AuthException.fromException(e);
    }
  }

  /// Updates the password for the currently signed-in user with reauthentication
  /// Use this when you need to ensure the user is recently authenticated
  Future<void> updatePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw const NoCurrentUserException();
      }

      // Reauthenticate the user before password update
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      // Now update the password
      await user.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException.fromException(e);
    }
  }

  /// Sends a password reset email to the user
  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      throw AuthException.fromException(e);
    }
  }

  /// Completes the password reset process using the code from the email
  /// and sets a new password for the user
  Future<void> confirmPasswordReset({
    required String code,
    required String newPassword,
  }) async {
    try {
      await _firebaseAuth.confirmPasswordReset(
        code: code,
        newPassword: newPassword,
      );
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      throw AuthException.fromException(e);
    }
  }

  /// Verifies a password reset code is valid without resetting the password
  /// Returns the email address associated with the code
  Future<String> verifyPasswordResetCode({required String code}) async {
    try {
      return await _firebaseAuth.verifyPasswordResetCode(code);
    } on FirebaseAuthException catch (e) {
      throw AuthException.fromFirebaseAuth(e);
    } catch (e) {
      throw AuthException.fromException(e);
    }
  }

  /// Extracts the password reset code from a Firebase password reset URL
  /// This is typically used when handling deep links from password reset emails
  ///
  /// Example URL: https://yourapp.firebaseapp.com/__/auth/action?mode=resetPassword&oobCode=ABC123&apiKey=...
  /// Returns: "ABC123"
  static String? extractResetCodeFromUrl(String url) {
    try {
      final uri = Uri.parse(url);

      // Check if this is a Firebase auth action URL
      if (!uri.path.contains('/__/auth/action')) {
        return null;
      }

      // Check if it's a password reset action
      final mode = uri.queryParameters['mode'];
      if (mode != 'resetPassword') {
        return null;
      }

      // Extract the oobCode (out-of-band code)
      return uri.queryParameters['oobCode'];
    } catch (e) {
      return null;
    }
  }
}
