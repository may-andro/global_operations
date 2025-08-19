import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';

extension DeleteAccountFailureExtension on DeleteAccountFailure {
  String getLocalizedMessage(BuildContext context) {
    return switch (this) {
      final DeleteAccountNotSignedInFailure _ =>
        context.localizations.errorUserNotSignedIn,
      final DeleteAccountWrongPasswordFailure _ =>
        context.localizations.errorWrongPassword,
      final DeleteAccountRecentLoginRequiredFailure _ =>
        context.localizations.errorRecentLoginRequired,
      final DeleteAccountNetworkFailure _ => context.localizations.errorNetwork,
      final DeleteAccountTooManyRequestsFailure _ =>
        context.localizations.errorTooManyRequests,
      final DeleteAccountInvalidCredentialFailure _ =>
        context.localizations.errorInvalidCredential,
      final DeleteAccountUserDisabledFailure _ =>
        context.localizations.errorUserDisabled,
      final DeleteAccountValidationFailure _ =>
        context.localizations.errorValidationFailed,
      final DeleteAccountUnknownFailure failure =>
        context.localizations.errorUnexpected(
          failure.message ?? failure.cause.toString(),
        ),
    };
  }
}

extension GetUserProfileFailureExtension on GetUserProfileFailure {
  String getLocalizedMessage(BuildContext context) {
    return switch (this) {
      final GetUserProfileNotSignedInFailure _ =>
        context.localizations.errorUserNotSignedIn,
      final GetUserProfileMissingEmailFailure _ =>
        context.localizations.errorMissingEmail,
      final GetUserProfileAuthStateFailure _ =>
        context.localizations.errorAuthState,
      final GetUserProfileNetworkFailure _ =>
        context.localizations.errorNetworkConnection,
      final GetUserProfileUnknownFailure failure =>
        context.localizations.errorUnexpected(
          failure.message ?? failure.cause.toString(),
        ),
    };
  }
}

extension UpdatePasswordFailureExtension on UpdatePasswordFailure {
  String getLocalizedMessage(BuildContext context) {
    return switch (this) {
      final UpdatePasswordUserNotSignedInFailure _ =>
        context.localizations.errorUserNotSignedIn,
      final UpdatePasswordWrongPasswordFailure _ =>
        context.localizations.errorWrongPassword,
      final UpdatePasswordRecentLoginRequiredFailure _ =>
        context.localizations.errorRecentLoginRequired,
      final UpdatePasswordNetworkFailure _ =>
        context.localizations.errorNetwork,
      final UpdatePasswordTooManyRequestsFailure _ =>
        context.localizations.errorTooManyRequests,
      final UpdatePasswordInvalidCredentialFailure _ =>
        context.localizations.errorInvalidCredential,
      final UpdatePasswordUserDisabledFailure _ =>
        context.localizations.errorUserDisabled,
      final UpdatePasswordWeakPasswordFailure _ =>
        context.localizations.errorWeakPassword,
      final UpdatePasswordUnknownFailure failure =>
        context.localizations.errorUnexpected(
          failure.message ?? failure.cause.toString(),
        ),
    };
  }
}
