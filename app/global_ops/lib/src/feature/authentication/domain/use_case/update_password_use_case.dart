import 'package:equatable/equatable.dart';
import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

sealed class UpdatePasswordFailure extends BasicFailure {
  const UpdatePasswordFailure({super.message, super.cause});
}

class UpdatePasswordUserNotSignedInFailure extends UpdatePasswordFailure {
  const UpdatePasswordUserNotSignedInFailure({super.message, super.cause});
}

class UpdatePasswordWrongPasswordFailure extends UpdatePasswordFailure {
  const UpdatePasswordWrongPasswordFailure({super.message, super.cause});
}

class UpdatePasswordRecentLoginRequiredFailure extends UpdatePasswordFailure {
  const UpdatePasswordRecentLoginRequiredFailure({super.message, super.cause});
}

class UpdatePasswordNetworkFailure extends UpdatePasswordFailure {
  const UpdatePasswordNetworkFailure({super.message, super.cause});
}

class UpdatePasswordTooManyRequestsFailure extends UpdatePasswordFailure {
  const UpdatePasswordTooManyRequestsFailure({super.message, super.cause});
}

class UpdatePasswordInvalidCredentialFailure extends UpdatePasswordFailure {
  const UpdatePasswordInvalidCredentialFailure({super.message, super.cause});
}

class UpdatePasswordUserDisabledFailure extends UpdatePasswordFailure {
  const UpdatePasswordUserDisabledFailure({super.message, super.cause});
}

class UpdatePasswordWeakPasswordFailure extends UpdatePasswordFailure {
  const UpdatePasswordWeakPasswordFailure({super.message, super.cause});
}

class UpdatePasswordUnknownFailure extends UpdatePasswordFailure {
  const UpdatePasswordUnknownFailure({super.message, super.cause});
}

class UpdatePasswordParams extends Equatable {
  const UpdatePasswordParams({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });

  final String email;
  final String currentPassword;
  final String newPassword;

  @override
  List<Object?> get props => [email, currentPassword, newPassword];
}

class UpdatePasswordUseCase
    extends BaseUseCase<void, UpdatePasswordParams, UpdatePasswordFailure> {
  UpdatePasswordUseCase(this._userRepository);

  final UserRepository _userRepository;

  @override
  Future<Either<UpdatePasswordFailure, void>> execute(
    UpdatePasswordParams input,
  ) async {
    await _userRepository.updatePassword(
      email: input.email,
      currentPassword: input.currentPassword,
      newPassword: input.newPassword,
    );
    return const Right(null);
  }

  @override
  UpdatePasswordFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle Firebase Auth specific exceptions
    if (e is AuthException) {
      return switch (e) {
        NoCurrentUserException() => UpdatePasswordUserNotSignedInFailure(
          message: 'User is not signed in. Please log in to continue',
          cause: e,
        ),
        WrongPasswordException() => UpdatePasswordWrongPasswordFailure(
          message: 'Incorrect current password. Please try again',
          cause: e,
        ),
        RequiresRecentLoginException() =>
          UpdatePasswordRecentLoginRequiredFailure(
            message: 'Recent login required. Please sign in again to continue',
            cause: e,
          ),
        NetworkRequestFailedException() => UpdatePasswordNetworkFailure(
          message: 'Network error. Please check your connection and try again',
          cause: e,
        ),
        TooManyRequestsException() => UpdatePasswordTooManyRequestsFailure(
          message: 'Too many requests. Please wait and try again later',
          cause: e,
        ),
        InvalidCredentialException() => UpdatePasswordInvalidCredentialFailure(
          message: 'Invalid credentials provided',
          cause: e,
        ),
        UserDisabledException() => UpdatePasswordUserDisabledFailure(
          message:
              'This account has been disabled. Contact support for assistance',
          cause: e,
        ),
        WeakPasswordException() => UpdatePasswordWeakPasswordFailure(
          message:
              'New password is too weak. Please choose a stronger password',
          cause: e,
        ),
        _ => UpdatePasswordUnknownFailure(
          message: 'An unexpected authentication error occurred',
          cause: e,
        ),
      };
    }

    // Handle any other unexpected errors
    return UpdatePasswordUnknownFailure(
      message: 'An unexpected error occurred while updating password',
      cause: e,
    );
  }
}
