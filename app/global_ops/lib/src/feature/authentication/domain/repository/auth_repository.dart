import 'package:global_ops/src/feature/authentication/domain/domain.dart';

abstract class AuthRepository {
  /// Gets the current user
  UserProfileEntity? get currentUser;

  /// Checks if a user is currently signed in
  bool get isSignedIn;

  /// Stream of authentication state changes
  Stream<UserProfileEntity?> get authStateChanges;

  /// Signs in a user with email and password
  Future<String> login({required String email, required String password});

  /// Signs out the current user
  Future<void> logout();
}
