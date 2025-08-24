import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:flutter/foundation.dart';
import 'package:use_case/use_case.dart';

sealed class UploadRawImageFailure extends BasicFailure {
  const UploadRawImageFailure({super.message, super.cause});
}

class UploadRawImageValidationFailure extends UploadRawImageFailure {
  const UploadRawImageValidationFailure({super.message, super.cause});
}

class UploadRawImageStorageFailure extends UploadRawImageFailure {
  const UploadRawImageStorageFailure({super.message, super.cause});
}

class UploadRawImageNetworkFailure extends UploadRawImageFailure {
  const UploadRawImageNetworkFailure({super.message, super.cause});
}

class UploadRawImagePermissionFailure extends UploadRawImageFailure {
  const UploadRawImagePermissionFailure({super.message, super.cause});
}

class UploadRawImageSizeExceededFailure extends UploadRawImageFailure {
  const UploadRawImageSizeExceededFailure({super.message, super.cause});
}

class UploadRawImageCancelledFailure extends UploadRawImageFailure {
  const UploadRawImageCancelledFailure({super.message, super.cause});
}

class UploadRawImageUnknownFailure extends UploadRawImageFailure {
  const UploadRawImageUnknownFailure({super.message, super.cause});
}

class UploadRawImageParams {
  const UploadRawImageParams({required this.rawData, required this.fileName});

  final Uint8List rawData;
  final String fileName;
}

class UploadRawImageUseCase
    extends BaseUseCase<String, UploadRawImageParams, UploadRawImageFailure> {
  UploadRawImageUseCase(this._fbStorageController);

  final FbStorageController _fbStorageController;

  @protected
  @override
  FutureOr<Either<UploadRawImageFailure, String>> execute(
    UploadRawImageParams input,
  ) async {
    final uploadedUrl = await _fbStorageController.uploadRawDocument(
      input.fileName,
      input.rawData,
    );

    return Right(uploadedUrl);
  }

  @override
  UploadRawImageFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle Firebase Storage specific exceptions
    if (e is StorageUploadCancelledException) {
      return UploadRawImageCancelledFailure(
        message: 'Image upload was cancelled',
        cause: e,
      );
    }

    if (e is StorageUploadErrorException) {
      return UploadRawImageStorageFailure(
        message: 'Storage service error occurred during upload',
        cause: e,
      );
    }

    if (e is StorageUploadFailedException) {
      return UploadRawImageStorageFailure(
        message: 'Image upload failed due to storage error',
        cause: e,
      );
    }

    // Handle general error types by examining error message
    final errorMessage = e.toString().toLowerCase();

    // Network-related errors
    if (errorMessage.contains('network') ||
        errorMessage.contains('connection') ||
        errorMessage.contains('timeout') ||
        errorMessage.contains('unreachable') ||
        errorMessage.contains('no internet')) {
      return UploadRawImageNetworkFailure(
        message: 'Network connection failed during upload',
        cause: e,
      );
    }

    // Permission-related errors
    if (errorMessage.contains('permission') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('forbidden') ||
        errorMessage.contains('access denied')) {
      return UploadRawImagePermissionFailure(
        message: 'Permission denied to upload images',
        cause: e,
      );
    }

    // File size or storage quota errors
    if (errorMessage.contains('quota') ||
        errorMessage.contains('storage limit') ||
        errorMessage.contains('file too large') ||
        errorMessage.contains('size exceeded')) {
      return UploadRawImageSizeExceededFailure(
        message: 'File size or storage quota exceeded',
        cause: e,
      );
    }

    // Validation-related errors
    if (errorMessage.contains('invalid') ||
        errorMessage.contains('format') ||
        errorMessage.contains('corrupt') ||
        errorMessage.contains('unsupported')) {
      return UploadRawImageValidationFailure(
        message: 'Invalid file format or corrupted file',
        cause: e,
      );
    }

    // Default to unknown failure
    return UploadRawImageUnknownFailure(
      message: 'An unexpected error occurred during image upload',
      cause: e,
    );
  }
}
