import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

extension UploadImageFileFailureExtension on UploadImageFileFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      UploadImageFileNetworkFailure() =>
        context.localizations.errorNetworkConnection,
      UploadImageFileSizeExceededFailure() =>
        context.localizations.errorImageSizeExceeded,
      UploadImageFileCancelledFailure() =>
        context.localizations.errorUploadCancelled,
      UploadImageFilePermissionFailure() =>
        context.localizations.errorPermissionDenied,
      UploadImageFileValidationFailure() =>
        context.localizations.errorInvalidFile,
      UploadImageFileStorageFailure() =>
        context.localizations.errorStorageService,
      UploadImageFileUnknownFailure() =>
        context.localizations.errorUploadUnknown,
    };
  }
}

extension UploadRawImageFailureExtension on UploadRawImageFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      UploadRawImageNetworkFailure() =>
        context.localizations.errorNetworkConnection,
      UploadRawImageSizeExceededFailure() =>
        context.localizations.errorImageSizeExceeded,
      UploadRawImageCancelledFailure() =>
        context.localizations.errorUploadCancelled,
      UploadRawImagePermissionFailure() =>
        context.localizations.errorPermissionDenied,
      UploadRawImageValidationFailure() =>
        context.localizations.errorInvalidFile,
      UploadRawImageStorageFailure() =>
        context.localizations.errorStorageService,
      UploadRawImageUnknownFailure() =>
        context.localizations.errorUploadUnknown,
    };
  }
}

extension UpdateAdPanelsFailureExtension on UpdateAdPanelsFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      UpdateAdPanelsValidationFailure() =>
        context.localizations.errorValidationFailed,
      UpdateAdPanelsServerFailure() =>
        context.localizations.errorServerUnavailable,
      UpdateAdPanelsUserNotFoundFailure() =>
        context.localizations.errorSessionExpired,
      UpdateAdPanelsUnknownFailure() => context.localizations.errorUpdateFailed,
    };
  }
}
