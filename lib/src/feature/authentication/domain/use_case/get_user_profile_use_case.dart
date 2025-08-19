import 'dart:async';

import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:use_case/use_case.dart';

sealed class GetUserProfileFailure extends BasicFailure {
  const GetUserProfileFailure({super.message, super.cause});
}

class GetUserProfileNotSignedInFailure extends GetUserProfileFailure {
  const GetUserProfileNotSignedInFailure({super.message, super.cause});
}

class GetUserProfileMissingEmailFailure extends GetUserProfileFailure {
  const GetUserProfileMissingEmailFailure({super.message, super.cause});
}

class GetUserProfileAuthStateFailure extends GetUserProfileFailure {
  const GetUserProfileAuthStateFailure({super.message, super.cause});
}

class GetUserProfileNetworkFailure extends GetUserProfileFailure {
  const GetUserProfileNetworkFailure({super.message, super.cause});
}

class GetUserProfileUnknownFailure extends GetUserProfileFailure {
  const GetUserProfileUnknownFailure({super.message, super.cause});
}

class GetUserProfileUseCase
    extends BaseNoParamUseCase<UserProfileEntity, GetUserProfileFailure> {
  GetUserProfileUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  FutureOr<Either<GetUserProfileFailure, UserProfileEntity>> execute() {
    // Check if user is signed in first
    if (!_authRepository.isSignedIn) {
      return const Left(
        GetUserProfileNotSignedInFailure(
          message: 'No user is currently signed in',
        ),
      );
    }

    final user = _authRepository.currentUser;

    // This should not happen if isSignedIn is true, but handle it safely
    if (user == null) {
      return const Left(
        GetUserProfileAuthStateFailure(
          message: 'Authentication state is inconsistent',
        ),
      );
    }

    // Check if user has email (AuthRepositoryImpl returns null if no email)
    if (user.email.isEmpty) {
      return const Left(
        GetUserProfileMissingEmailFailure(
          message: 'User account is missing required email information',
        ),
      );
    }

    return Right(user);
  }

  @override
  GetUserProfileFailure mapErrorToFailure(Object e, StackTrace st) {
    final errorMessage = e.toString().toLowerCase();

    // Network-related errors from Firebase Auth
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('unreachable')) {
      return GetUserProfileNetworkFailure(
        message: 'Network error while retrieving user profile',
        cause: e,
      );
    }

    // Authentication state errors
    if (errorMessage.contains('auth') ||
        errorMessage.contains('signed') ||
        errorMessage.contains('token') ||
        errorMessage.contains('credential')) {
      return GetUserProfileAuthStateFailure(
        message: 'Authentication state error while retrieving user profile',
        cause: e,
      );
    }

    // Default to unknown failure
    return GetUserProfileUnknownFailure(
      message: 'An unexpected error occurred while retrieving user profile',
      cause: e,
    );
  }
}
