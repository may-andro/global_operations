import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:use_case/use_case.dart';

sealed class CompressRawImageFailure extends BasicFailure {
  const CompressRawImageFailure({super.message, super.cause});
}

class CompressRawImageValidationFailure extends CompressRawImageFailure {
  const CompressRawImageValidationFailure({super.message, super.cause});
}

class CompressRawImageDecodingFailure extends CompressRawImageFailure {
  const CompressRawImageDecodingFailure({super.message, super.cause});
}

class CompressRawImageProcessingFailure extends CompressRawImageFailure {
  const CompressRawImageProcessingFailure({super.message, super.cause});
}

class CompressRawImageFileSystemFailure extends CompressRawImageFailure {
  const CompressRawImageFileSystemFailure({super.message, super.cause});
}

class CompressRawImageUnknownFailure extends CompressRawImageFailure {
  const CompressRawImageUnknownFailure({super.message, super.cause});
}

class CompressRawImageUseCase
    extends BaseUseCase<File, Uint8List, CompressRawImageFailure> {
  @override
  FutureOr<Either<CompressRawImageFailure, File>> execute(
    Uint8List imageBytes,
  ) async {
    if (imageBytes.isEmpty) {
      return const Left(
        CompressRawImageValidationFailure(message: 'Empty image bytes'),
      );
    }

    // Run heavy image processing in background isolate to prevent UI freezing
    final compressedBytes = await compute(
      _compressRawImageInIsolate,
      _ImageProcessingParams(imageBytes: imageBytes),
    );

    // Create temporary file with unique name to avoid conflicts
    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final tempFile = File(
      '${tempDir.path}/compressed_${timestamp}_${UniqueKey()}.jpg',
    );

    // Write compressed image to file - BaseUseCase will catch any exceptions
    await tempFile.writeAsBytes(compressedBytes);

    return Right(tempFile);
  }

  @override
  CompressRawImageFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle FileSystemException for file operations
    if (e is FileSystemException) {
      return CompressRawImageFileSystemFailure(
        message: 'File system error: ${e.message}',
        cause: e,
      );
    }

    // Handle FormatException for image decoding issues
    if (e is FormatException) {
      return CompressRawImageDecodingFailure(
        message: 'Image format error: ${e.message}',
        cause: e,
      );
    }

    // Handle ArgumentError for invalid parameters during image processing
    if (e is ArgumentError) {
      return CompressRawImageValidationFailure(
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
      return CompressRawImageFileSystemFailure(
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
      return CompressRawImageProcessingFailure(
        message: 'Image processing operation failed',
        cause: e,
      );
    }

    // Memory-related errors
    if (errorMessage.contains('memory') ||
        errorMessage.contains('out of memory') ||
        errorMessage.contains('allocation')) {
      return CompressRawImageProcessingFailure(
        message: 'Memory error during image processing',
        cause: e,
      );
    }

    // Default to unknown failure
    return CompressRawImageUnknownFailure(
      message: 'An unexpected error occurred during image compression',
      cause: e,
    );
  }

  /// Isolate entry point for heavy image processing
  static Uint8List _compressRawImageInIsolate(_ImageProcessingParams params) {
    final imageBytes = params.imageBytes;

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

/// Parameters for image processing isolate
class _ImageProcessingParams {
  _ImageProcessingParams({
    required this.imageBytes,
  });

  final Uint8List imageBytes;
}
