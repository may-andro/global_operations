import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:path/path.dart';
import 'package:use_case/use_case.dart';

sealed class CompressImageFileFailure extends BasicFailure {
  const CompressImageFileFailure({super.message, super.cause});
}

class CompressImageFileValidationFailure extends CompressImageFileFailure {
  const CompressImageFileValidationFailure({super.message, super.cause});
}

class CompressImageFileDecodingFailure extends CompressImageFileFailure {
  const CompressImageFileDecodingFailure({super.message, super.cause});
}

class CompressImageFileProcessingFailure extends CompressImageFileFailure {
  const CompressImageFileProcessingFailure({super.message, super.cause});
}

class CompressImageFileFileSystemFailure extends CompressImageFileFailure {
  const CompressImageFileFileSystemFailure({super.message, super.cause});
}

class CompressImageFileUnknownFailure extends CompressImageFileFailure {
  const CompressImageFileUnknownFailure({super.message, super.cause});
}

class CompressImageFileUseCase
    extends BaseUseCase<File, File, CompressImageFileFailure> {
  @override
  FutureOr<Either<CompressImageFileFailure, File>> execute(File file) async {
    // Validate input file
    if (!await file.exists()) {
      return Left(
        CompressImageFileValidationFailure(
          message: 'File does not exist: ${file.path}',
        ),
      );
    }

    // Validate file size (optional - prevent processing extremely large files)
    final fileSize = await file.length();
    const maxSizeInBytes = 50 * 1024 * 1024; // 50MB limit
    if (fileSize > maxSizeInBytes) {
      return Left(
        CompressImageFileValidationFailure(
          message: 'File size exceeds 50MB limit: ${file.path}',
        ),
      );
    }

    // Read the image file - BaseUseCase will catch any exceptions
    final imageBytes = await file.readAsBytes();

    // Run heavy image processing in background isolate to prevent UI freezing
    final compressedBytes = await compute(
      _compressImageFileInIsolate,
      _ImageProcessingParams(imageBytes: imageBytes, originalPath: file.path),
    );

    // Create temporary file with unique name to avoid conflicts
    final tempDir = Directory.systemTemp;
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final baseName = basenameWithoutExtension(file.path);
    final tempFile = File(
      '${tempDir.path}/${baseName}_compressed_${timestamp}_${UniqueKey()}.jpg',
    );

    // Write compressed image to file - BaseUseCase will catch any exceptions
    await tempFile.writeAsBytes(compressedBytes);

    return Right(tempFile);
  }

  @override
  CompressImageFileFailure mapErrorToFailure(Object e, StackTrace st) {
    // Handle FileSystemException for file operations
    if (e is FileSystemException) {
      return CompressImageFileFileSystemFailure(
        message: 'File system error: ${e.message}',
        cause: e,
      );
    }

    // Handle FormatException for image decoding issues
    if (e is FormatException) {
      return CompressImageFileDecodingFailure(
        message: 'Image format error: ${e.message}',
        cause: e,
      );
    }

    // Handle ArgumentError for invalid parameters during image processing
    if (e is ArgumentError) {
      return CompressImageFileValidationFailure(
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
      return CompressImageFileFileSystemFailure(
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
      return CompressImageFileProcessingFailure(
        message: 'Image processing operation failed',
        cause: e,
      );
    }

    // Memory-related errors
    if (errorMessage.contains('memory') ||
        errorMessage.contains('out of memory') ||
        errorMessage.contains('allocation')) {
      return CompressImageFileProcessingFailure(
        message: 'Memory error during image processing',
        cause: e,
      );
    }

    // Default to unknown failure
    return CompressImageFileUnknownFailure(
      message: 'An unexpected error occurred during image compression',
      cause: e,
    );
  }

  /// Isolate entry point for heavy image processing
  static Uint8List _compressImageFileInIsolate(_ImageProcessingParams params) {
    final imageBytes = params.imageBytes;
    final originalPath = params.originalPath;

    // Decode the image - BaseUseCase will catch any exceptions
    final image = decodeImage(imageBytes);

    if (image == null) {
      throw FormatException('Failed to decode image: $originalPath');
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
    required this.originalPath,
  });

  final Uint8List imageBytes;
  final String originalPath;
}
