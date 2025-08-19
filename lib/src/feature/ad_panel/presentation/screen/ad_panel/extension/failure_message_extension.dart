import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

extension UploadAdPanelImageFailureExtension on UploadAdPanelImageFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      UploadAdPanelImageNetworkFailure() =>
        context.localizations.errorNetworkConnection,
      UploadAdPanelImageSizeExceededFailure() =>
        context.localizations.errorImageSizeExceeded,
      UploadAdPanelImageCancelledFailure() =>
        context.localizations.errorUploadCancelled,
      UploadAdPanelImagePermissionFailure() =>
        context.localizations.errorPermissionDenied,
      UploadAdPanelImageValidationFailure() =>
        context.localizations.errorInvalidFile,
      UploadAdPanelImageStorageFailure() =>
        context.localizations.errorStorageService,
      UploadAdPanelImageUnknownFailure() =>
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
