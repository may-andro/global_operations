import 'dart:async';
import 'dart:io';

import 'package:firebase/firebase.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

sealed class UploadImageFileFailure extends BasicFailure {
  const UploadImageFileFailure({super.message, super.cause});
}

class UploadImageFileValidationFailure extends UploadImageFileFailure {
  const UploadImageFileValidationFailure({super.message, super.cause});
}

class UploadImageFileStorageFailure extends UploadImageFileFailure {
  const UploadImageFileStorageFailure({super.message, super.cause});
}

class UploadImageFileNetworkFailure extends UploadImageFileFailure {
  const UploadImageFileNetworkFailure({super.message, super.cause});
}

class UploadImageFilePermissionFailure extends UploadImageFileFailure {
  const UploadImageFilePermissionFailure({super.message, super.cause});
}

class UploadImageFileSizeExceededFailure extends UploadImageFileFailure {
  const UploadImageFileSizeExceededFailure({super.message, super.cause});
}

class UploadImageFileCancelledFailure extends UploadImageFileFailure {
  const UploadImageFileCancelledFailure({super.message, super.cause});
}

class UploadImageFileUnknownFailure extends UploadImageFileFailure {
  const UploadImageFileUnknownFailure({super.message, super.cause});
}

class UploadImageFileParams {
  const UploadImageFileParams({required this.file, required this.fileName});

  final File file;
  final String fileName;
}

class UploadImageFileUseCase
    extends BaseUseCase<String, UploadImageFileParams, UploadImageFileFailure> {
  UploadImageFileUseCase(this._fbStorageController);

  final FbStorageController _fbStorageController;

  @protected
  @override
  FutureOr<Either<UploadImageFileFailure, String>> execute(
    UploadImageFileParams input,
  ) async {
    // Validate file existence and size
    final file = input.file;
    if (!await file.exists()) {
      return Left(
        UploadImageFileValidationFailure(
          message: 'File does not exist: ${file.path}',
        ),
      );
    }

    // Check file size (Firebase Storage has a 5GB limit, but for images we should be more restrictive)
    final fileSize = await file.length();
    const maxSizeInBytes = 5 * 1024 * 1024; // 5MB limit for images
    if (fileSize > maxSizeInBytes) {
      return Left(
        UploadImageFileSizeExceededFailure(
          message: 'File size exceeds 10MB limit: ${file.path}',
        ),
      );
    }

    final uploadedUrl = await _fbStorageController.uploadFileDocument(
      input.fileName,
      file,
    );

    return Right(uploadedUrl);
  }

  @override
  UploadImageFileFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle Firebase Storage specific exceptions
    if (e is StorageUploadCancelledException) {
      return UploadImageFileCancelledFailure(
        message: 'Image upload was cancelled',
        cause: e,
      );
    }

    if (e is StorageUploadErrorException) {
      return UploadImageFileStorageFailure(
        message: 'Storage service error occurred during upload',
        cause: e,
      );
    }

    if (e is StorageUploadFailedException) {
      return UploadImageFileStorageFailure(
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
      return UploadImageFileNetworkFailure(
        message: 'Network connection failed during upload',
        cause: e,
      );
    }

    // Permission-related errors
    if (errorMessage.contains('permission') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('forbidden') ||
        errorMessage.contains('access denied')) {
      return UploadImageFilePermissionFailure(
        message: 'Permission denied to upload images',
        cause: e,
      );
    }

    // File size or storage quota errors
    if (errorMessage.contains('quota') ||
        errorMessage.contains('storage limit') ||
        errorMessage.contains('file too large') ||
        errorMessage.contains('size exceeded')) {
      return UploadImageFileSizeExceededFailure(
        message: 'File size or storage quota exceeded',
        cause: e,
      );
    }

    // Validation-related errors
    if (errorMessage.contains('invalid') ||
        errorMessage.contains('format') ||
        errorMessage.contains('corrupt') ||
        errorMessage.contains('unsupported')) {
      return UploadImageFileValidationFailure(
        message: 'Invalid file format or corrupted file',
        cause: e,
      );
    }

    // Default to unknown failure
    return UploadImageFileUnknownFailure(
      message: 'An unexpected error occurred during image upload',
      cause: e,
    );
  }
}
