import 'dart:async';
import 'dart:io';

import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

sealed class UploadAdPanelImageFailure extends BasicFailure {
  const UploadAdPanelImageFailure({super.message, super.cause});
}

class UploadAdPanelImageValidationFailure extends UploadAdPanelImageFailure {
  const UploadAdPanelImageValidationFailure({super.message, super.cause});
}

class UploadAdPanelImageStorageFailure extends UploadAdPanelImageFailure {
  const UploadAdPanelImageStorageFailure({super.message, super.cause});
}

class UploadAdPanelImageNetworkFailure extends UploadAdPanelImageFailure {
  const UploadAdPanelImageNetworkFailure({super.message, super.cause});
}

class UploadAdPanelImagePermissionFailure extends UploadAdPanelImageFailure {
  const UploadAdPanelImagePermissionFailure({super.message, super.cause});
}

class UploadAdPanelImageSizeExceededFailure extends UploadAdPanelImageFailure {
  const UploadAdPanelImageSizeExceededFailure({super.message, super.cause});
}

class UploadAdPanelImageCancelledFailure extends UploadAdPanelImageFailure {
  const UploadAdPanelImageCancelledFailure({super.message, super.cause});
}

class UploadAdPanelImageUnknownFailure extends UploadAdPanelImageFailure {
  const UploadAdPanelImageUnknownFailure({super.message, super.cause});
}

class UploadAdPanelImageParams {
  const UploadAdPanelImageParams({required this.file, required this.abPanel});

  final File file;
  final AdPanelEntity abPanel;
}

class UploadAdPanelImageUseCase
    extends
        BaseUseCase<
          String,
          UploadAdPanelImageParams,
          UploadAdPanelImageFailure
        > {
  UploadAdPanelImageUseCase(this._fbStorageController);

  final FbStorageController _fbStorageController;

  @protected
  @override
  FutureOr<Either<UploadAdPanelImageFailure, String>> execute(
    UploadAdPanelImageParams input,
  ) async {
    // Validate file existence and size
    final file = input.file;
    if (!await file.exists()) {
      return Left(
        UploadAdPanelImageValidationFailure(
          message: 'File does not exist: ${file.path}',
        ),
      );
    }

    // Check file size (Firebase Storage has a 5GB limit, but for images we should be more restrictive)
    final fileSize = await file.length();
    const maxSizeInBytes = 10 * 1024 * 1024; // 10MB limit for images
    if (fileSize > maxSizeInBytes) {
      return Left(
        UploadAdPanelImageSizeExceededFailure(
          message: 'File size exceeds 10MB limit: ${file.path}',
        ),
      );
    }

    final fileName = '${input.abPanel.key}_${DateTime.now().toUtc()}';
    final uploadedUrl = await _fbStorageController.uploadFileDocument(
      fileName,
      file,
    );

    return Right(uploadedUrl);
  }

  @override
  UploadAdPanelImageFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle Firebase Storage specific exceptions
    if (e is StorageUploadCancelledException) {
      return UploadAdPanelImageCancelledFailure(
        message: 'Image upload was cancelled',
        cause: e,
      );
    }

    if (e is StorageUploadErrorException) {
      return UploadAdPanelImageStorageFailure(
        message: 'Storage service error occurred during upload',
        cause: e,
      );
    }

    if (e is StorageUploadFailedException) {
      return UploadAdPanelImageStorageFailure(
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
      return UploadAdPanelImageNetworkFailure(
        message: 'Network connection failed during upload',
        cause: e,
      );
    }

    // Permission-related errors
    if (errorMessage.contains('permission') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('forbidden') ||
        errorMessage.contains('access denied')) {
      return UploadAdPanelImagePermissionFailure(
        message: 'Permission denied to upload images',
        cause: e,
      );
    }

    // File size or storage quota errors
    if (errorMessage.contains('quota') ||
        errorMessage.contains('storage limit') ||
        errorMessage.contains('file too large') ||
        errorMessage.contains('size exceeded')) {
      return UploadAdPanelImageSizeExceededFailure(
        message: 'File size or storage quota exceeded',
        cause: e,
      );
    }

    // Validation-related errors
    if (errorMessage.contains('invalid') ||
        errorMessage.contains('format') ||
        errorMessage.contains('corrupt') ||
        errorMessage.contains('unsupported')) {
      return UploadAdPanelImageValidationFailure(
        message: 'Invalid file format or corrupted file',
        cause: e,
      );
    }

    // Default to unknown failure
    return UploadAdPanelImageUnknownFailure(
      message: 'An unexpected error occurred during image upload',
      cause: e,
    );
  }
}
