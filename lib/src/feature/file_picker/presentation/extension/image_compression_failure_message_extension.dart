import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/file_picker/domain/domain.dart';

extension ImagePickerFailureExtension on ImagePickerFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      ImagePickerValidationFailure() => context.localizations.errorInvalidFile,
      ImagePickerDecodingFailure() => context.localizations.errorDecodingFile,
      ImagePickerProcessingFailure() =>
        context.localizations.errorProcessingFile,
      ImagePickerFileSystemFailure() =>
        context.localizations.errorPermissionDenied,
      ImagePickerUnknownFailure() => context.localizations.errorUnknownFile,
      ImagePickerFileTooBigFailure() =>
        context.localizations.errorImageSizeExceeded,
    };
  }
}

extension FilePickerFailureExtension on FilePickerFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      FilePickerValidationFailure() => context.localizations.errorInvalidFile,
      FilePickerDecodingFailure() => context.localizations.errorDecodingFile,
      FilePickerProcessingFailure() =>
        context.localizations.errorProcessingFile,
      FilePickerFileSystemFailure() =>
        context.localizations.errorPermissionDenied,
      FilePickerUnknownFailure() => context.localizations.errorUnknownFile,
      FilePickerFileTooBigFailure() =>
        context.localizations.errorImageSizeExceeded,
    };
  }
}
