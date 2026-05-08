import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:use_case/use_case.dart';

sealed class FilePickerFailure extends BasicFailure {
  const FilePickerFailure({super.message, super.cause});
}

class FilePickerValidationFailure extends FilePickerFailure {
  const FilePickerValidationFailure({super.message, super.cause});
}

class FilePickerDecodingFailure extends FilePickerFailure {
  const FilePickerDecodingFailure({super.message, super.cause});
}

class FilePickerProcessingFailure extends FilePickerFailure {
  const FilePickerProcessingFailure({super.message, super.cause});
}

class FilePickerFileSystemFailure extends FilePickerFailure {
  const FilePickerFileSystemFailure({super.message, super.cause});
}

class FilePickerUnknownFailure extends FilePickerFailure {
  const FilePickerUnknownFailure({super.message, super.cause});
}

class FilePickerFileTooBigFailure extends FilePickerFailure {
  const FilePickerFileTooBigFailure({super.message, super.cause});
}

class FilePickerUseCase
    extends BaseNoParamUseCase<Uint8List, FilePickerFailure> {
  @protected
  @override
  FutureOr<Either<FilePickerFailure, Uint8List>> execute() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
      withData: true,
      compressionQuality: 40,
    );

    if (result == null) {
      return const Left(FilePickerValidationFailure());
    }

    if (result.files.isEmpty) {
      return const Left(FilePickerValidationFailure());
    }

    final bytes = result.files.first.bytes;

    if (bytes == null) {
      return const Left(FilePickerValidationFailure());
    }

    final fileSize = bytes.lengthInBytes;
    const maxSizeInBytes = 5 * 1024 * 1024; // 5MB limit
    if (fileSize > maxSizeInBytes) {
      return const Left(FilePickerFileTooBigFailure());
    }

    // Run heavy image processing in background isolate to prevent UI freezing
    final compressedBytes = await compute(_compressImageFileInIsolate, bytes);

    if (compressedBytes.isEmpty) {
      return const Left(FilePickerProcessingFailure());
    }
    return Right(compressedBytes);
  }

  @protected
  @override
  FilePickerFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle FileSystemException for file operations
    if (e is FileSystemException) {
      return FilePickerFileSystemFailure(
        message: 'File system error: ${e.message}',
        cause: e,
      );
    }

    // Handle FormatException for image decoding issues
    if (e is FormatException) {
      return FilePickerDecodingFailure(
        message: 'Image format error: ${e.message}',
        cause: e,
      );
    }

    // Handle ArgumentError for invalid parameters during image processing
    if (e is ArgumentError) {
      return FilePickerValidationFailure(
        message: 'Invalid argument: ${e.message}',
        cause: e,
      );
    }

    // Handle general error types by examining error message
    final errorMessage = e.toString().toLowerCase();

    // File-related errors
    if (errorMessage.contains('file') ||
        errorMessage.contains('directory') ||
        errorMessage.contains('path') ||
        errorMessage.contains('permission denied') ||
        errorMessage.contains('access denied')) {
      return FilePickerFileSystemFailure(
        message: 'File system operation failed',
        cause: e,
      );
    }

    // Image processing errors
    if (errorMessage.contains('decode') ||
        errorMessage.contains('encode') ||
        errorMessage.contains('image') ||
        errorMessage.contains('format') ||
        errorMessage.contains('corrupt')) {
      return FilePickerProcessingFailure(
        message: 'Image processing operation failed',
        cause: e,
      );
    }

    // Memory-related errors
    if (errorMessage.contains('memory') ||
        errorMessage.contains('out of memory') ||
        errorMessage.contains('allocation')) {
      return FilePickerProcessingFailure(
        message: 'Memory error during image processing',
        cause: e,
      );
    }

    // Default to unknown failure
    return FilePickerUnknownFailure(
      message: 'An unexpected error occurred during image compression',
      cause: e,
    );
  }

  static Uint8List _compressImageFileInIsolate(Uint8List imageBytes) {
    final image = decodeImage(imageBytes);

    if (image == null) {
      throw const FormatException('Failed to decode image');
    }

    // Apply image processing optimizations
    final processedImage = _processImage(image);

    // Encode to JPEG with high quality (90%) for good balance between quality and size
    final compressedBytes = encodeJpg(processedImage, quality: 90);

    return compressedBytes;
  }
}

/// Processes the image with optimal settings for compression while maintaining quality
Image _processImage(Image image) {
  // Apply orientation correction if needed (for photos taken with camera)
  var processedImage = bakeOrientation(image);

  // Determine optimal dimensions - use 1920px as max for high quality while reducing size
  const maxDimension = 1920;
  int targetWidth = processedImage.width;
  int targetHeight = processedImage.height;

  if (processedImage.width > maxDimension ||
      processedImage.height > maxDimension) {
    final aspectRatio = processedImage.width / processedImage.height;

    if (processedImage.width > processedImage.height) {
      // Landscape orientation
      targetWidth = maxDimension;
      targetHeight = (maxDimension / aspectRatio).round();
    } else {
      // Portrait orientation
      targetHeight = maxDimension;
      targetWidth = (maxDimension * aspectRatio).round();
    }

    // Resize with high-quality interpolation
    processedImage = copyResize(
      processedImage,
      width: targetWidth,
      height: targetHeight,
      interpolation: Interpolation.cubic,
    );
  }

  // Apply subtle sharpening for better quality after resize
  if (targetWidth != processedImage.width ||
      targetHeight != processedImage.height) {
    processedImage = convolution(
      processedImage,
      filter: [0, -1, 0, -1, 5, -1, 0, -1, 0],
      div: 1,
    );
  }

  return processedImage;
}
