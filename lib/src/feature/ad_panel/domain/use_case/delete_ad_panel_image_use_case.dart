import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

sealed class DeleteAdPanelImageFailure extends BasicFailure {
  const DeleteAdPanelImageFailure({super.message, super.cause});
}

class DeleteAdPanelImageValidationFailure extends DeleteAdPanelImageFailure {
  const DeleteAdPanelImageValidationFailure({super.message, super.cause});
}

class DeleteAdPanelImageStorageFailure extends DeleteAdPanelImageFailure {
  const DeleteAdPanelImageStorageFailure({super.message, super.cause});
}

class DeleteAdPanelImageNetworkFailure extends DeleteAdPanelImageFailure {
  const DeleteAdPanelImageNetworkFailure({super.message, super.cause});
}

class DeleteAdPanelImagePermissionFailure extends DeleteAdPanelImageFailure {
  const DeleteAdPanelImagePermissionFailure({super.message, super.cause});
}

class DeleteAdPanelImageUnknownFailure extends DeleteAdPanelImageFailure {
  const DeleteAdPanelImageUnknownFailure({super.message, super.cause});
}

class DeleteAdPanelImageUseCase
    extends BaseUseCase<void, String, DeleteAdPanelImageFailure> {
  DeleteAdPanelImageUseCase(this._fbStorageController);

  final FbStorageController _fbStorageController;

  @protected
  @override
  FutureOr<Either<DeleteAdPanelImageFailure, void>> execute(
    String fileUrl,
  ) async {
    // Validate input URL
    if (fileUrl.isEmpty) {
      return const Left(
        DeleteAdPanelImageValidationFailure(
          message: 'File URL cannot be empty',
        ),
      );
    }

    // Extract file name from Firebase Storage URL
    final fileName = _extractFileNameFromUrl(fileUrl);
    if (fileName == null) {
      return const Left(
        DeleteAdPanelImageValidationFailure(
          message: 'Invalid Firebase Storage URL format',
        ),
      );
    }

    // Delete the file from Firebase Storage
    await _fbStorageController.deleteFileDocument(fileName);

    return const Right(null);
  }

  /// Extracts the file name/path from a Firebase Storage download URL
  String? _extractFileNameFromUrl(String url) {
    try {
      // Firebase Storage URLs have format:
      // https://firebasestorage.googleapis.com/v0/b/{bucket}/o/{fileName}?{params}
      final uri = Uri.parse(url);

      if (!uri.host.contains('firebasestorage.googleapis.com')) {
        return null;
      }

      // Extract the file path from the 'o' parameter
      final pathSegments = uri.pathSegments;
      final oIndex = pathSegments.indexOf('o');

      if (oIndex == -1 || oIndex + 1 >= pathSegments.length) {
        return null;
      }

      // Decode the URL-encoded file name
      return Uri.decodeComponent(pathSegments[oIndex + 1]);
    } catch (e) {
      return null;
    }
  }

  @override
  DeleteAdPanelImageFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle Firebase Storage specific exceptions
    if (e is StorageDeleteErrorException) {
      return DeleteAdPanelImageStorageFailure(
        message: 'Failed to delete file from storage',
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
      return DeleteAdPanelImageNetworkFailure(
        message: 'Network connection failed during deletion',
        cause: e,
      );
    }

    // Permission-related errors
    if (errorMessage.contains('permission') ||
        errorMessage.contains('unauthorized') ||
        errorMessage.contains('forbidden') ||
        errorMessage.contains('access denied')) {
      return DeleteAdPanelImagePermissionFailure(
        message: 'Permission denied to delete file',
        cause: e,
      );
    }

    // Storage-related errors
    if (errorMessage.contains('storage') ||
        errorMessage.contains('bucket') ||
        errorMessage.contains('file not found') ||
        errorMessage.contains('does not exist')) {
      return DeleteAdPanelImageStorageFailure(
        message: 'Storage operation failed or file not found',
        cause: e,
      );
    }

    // Validation-related errors
    if (errorMessage.contains('invalid') ||
        errorMessage.contains('format') ||
        errorMessage.contains('url') ||
        errorMessage.contains('malformed')) {
      return DeleteAdPanelImageValidationFailure(
        message: 'Invalid file URL or format',
        cause: e,
      );
    }

    // Default to unknown failure
    return DeleteAdPanelImageUnknownFailure(
      message: 'An unexpected error occurred during image deletion',
      cause: e,
    );
  }
}
