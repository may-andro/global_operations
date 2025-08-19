import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

sealed class DeleteAccountFailure extends BasicFailure {
  const DeleteAccountFailure({super.message, super.cause});
}

class DeleteAccountNotSignedInFailure extends DeleteAccountFailure {
  const DeleteAccountNotSignedInFailure({super.message, super.cause});
}

class DeleteAccountWrongPasswordFailure extends DeleteAccountFailure {
  const DeleteAccountWrongPasswordFailure({super.message, super.cause});
}

class DeleteAccountRecentLoginRequiredFailure extends DeleteAccountFailure {
  const DeleteAccountRecentLoginRequiredFailure({super.message, super.cause});
}

class DeleteAccountNetworkFailure extends DeleteAccountFailure {
  const DeleteAccountNetworkFailure({super.message, super.cause});
}

class DeleteAccountTooManyRequestsFailure extends DeleteAccountFailure {
  const DeleteAccountTooManyRequestsFailure({super.message, super.cause});
}

class DeleteAccountInvalidCredentialFailure extends DeleteAccountFailure {
  const DeleteAccountInvalidCredentialFailure({super.message, super.cause});
}

class DeleteAccountUserDisabledFailure extends DeleteAccountFailure {
  const DeleteAccountUserDisabledFailure({super.message, super.cause});
}

class DeleteAccountValidationFailure extends DeleteAccountFailure {
  const DeleteAccountValidationFailure({super.message, super.cause});
}

class DeleteAccountUnknownFailure extends DeleteAccountFailure {
  const DeleteAccountUnknownFailure({super.message, super.cause});
}

class DeleteAccountParams extends Equatable {
  const DeleteAccountParams({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class DeleteAccountUseCase
    extends BaseUseCase<void, DeleteAccountParams, DeleteAccountFailure> {
  DeleteAccountUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<DeleteAccountFailure, void>> execute(
    DeleteAccountParams input,
  ) async {
    // Validate input parameters
    if (input.email.trim().isEmpty) {
      return const Left(
        DeleteAccountValidationFailure(
          message: 'Email is required for account deletion',
        ),
      );
    }

    if (input.password.trim().isEmpty) {
      return const Left(
        DeleteAccountValidationFailure(
          message: 'Password is required for account deletion',
        ),
      );
    }

    await _userRepository.deleteAccount(
      email: input.email,
      password: input.password,
    );
    return const Right(null);
  }

  @override
  DeleteAccountFailure mapErrorToFailure(Object e, StackTrace st) {
    final errorMessage = e.toString().toLowerCase();

    // No current user - not signed in
    if (errorMessage.contains('no user is currently signed in') ||
        errorMessage.contains('no current user')) {
      return DeleteAccountNotSignedInFailure(
        message: 'No user is currently signed in',
        cause: e,
      );
    }

    // Wrong password during reauthentication
    if (errorMessage.contains('wrong-password') ||
        errorMessage.contains('incorrect password')) {
      return DeleteAccountWrongPasswordFailure(
        message:
            'Incorrect password. Please verify your password and try again',
        cause: e,
      );
    }

    // Recent login required for sensitive operations
    if (errorMessage.contains('requires-recent-login') ||
        errorMessage.contains('recent authentication')) {
      return DeleteAccountRecentLoginRequiredFailure(
        message:
            'This action requires recent authentication. Please sign in again',
        cause: e,
      );
    }

    // Network-related errors
    if (errorMessage.contains('network-request-failed') ||
        errorMessage.contains('network error') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout')) {
      return DeleteAccountNetworkFailure(
        message: 'Network error. Please check your connection and try again',
        cause: e,
      );
    }

    // Too many failed attempts
    if (errorMessage.contains('too-many-requests') ||
        errorMessage.contains('too many failed attempts')) {
      return DeleteAccountTooManyRequestsFailure(
        message: 'Too many failed attempts. Please try again later',
        cause: e,
      );
    }

    // Invalid credentials
    if (errorMessage.contains('invalid-credential') ||
        errorMessage.contains('invalid email') ||
        errorMessage.contains('user-not-found')) {
      return DeleteAccountInvalidCredentialFailure(
        message: 'Invalid credentials provided',
        cause: e,
      );
    }

    // User account disabled
    if (errorMessage.contains('user-disabled') ||
        errorMessage.contains('account has been disabled')) {
      return DeleteAccountUserDisabledFailure(
        message: 'This account has been disabled',
        cause: e,
      );
    }

    // Input validation errors
    if (errorMessage.contains('email is required') ||
        errorMessage.contains('password is required') ||
        errorMessage.contains('validation')) {
      return DeleteAccountValidationFailure(
        message: 'Invalid input provided for account deletion',
        cause: e,
      );
    }

    // Default to unknown failure
    return DeleteAccountUnknownFailure(
      message: 'An unexpected error occurred while deleting account',
      cause: e,
    );
  }
}
