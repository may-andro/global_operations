import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

sealed class FireStorageException implements Exception {
  FireStorageException(this.cause, this.stackTrace);

  final Object cause;
  final StackTrace stackTrace;
}

final class StorageDownloadErrorException extends FireStorageException {
  StorageDownloadErrorException(super.cause, super.stackTrace);
}

final class StorageUploadErrorException extends FireStorageException {
  StorageUploadErrorException(super.cause, super.stackTrace);
}

final class StorageUploadCancelledException extends FireStorageException {
  StorageUploadCancelledException(super.cause, super.stackTrace);
}

final class StorageUploadPausedException extends FireStorageException {
  StorageUploadPausedException(super.cause, super.stackTrace);
}

final class StorageUploadRunningException extends FireStorageException {
  StorageUploadRunningException(super.cause, super.stackTrace);
}

final class StorageUploadFailedException extends FireStorageException {
  StorageUploadFailedException(super.cause, super.stackTrace);
}

final class StorageDeleteErrorException extends FireStorageException {
  StorageDeleteErrorException(super.cause, super.stackTrace);
}

class FbStorageController {
  FbStorageController(this._firebaseStorage);

  final FirebaseStorage _firebaseStorage;

  Future<String> uploadRawDocument(String fileName, Uint8List data) async {
    try {
      final storageRef = _firebaseStorage
          .refFromURL('gs://global-19c96.firebasestorage.app')
          .child(fileName);
      final uploadTask = await storageRef.putData(data);
      final exception = _mapFailureToException(uploadTask.state);
      if (exception == null) {
        return await storageRef.getDownloadURL();
      }
      throw exception;
    } catch (error, st) {
      throw StorageUploadFailedException(error, st);
    }
  }

  Future<String> uploadStringUrlDocument(
    String fileName,
    String dataUrl,
  ) async {
    try {
      final storageRef = _firebaseStorage
          .refFromURL('gs://global-19c96.firebasestorage.app')
          .child(fileName);
      final uploadTask = await storageRef.putString(
        dataUrl,
        format: PutStringFormat.dataUrl,
      );
      final exception = _mapFailureToException(uploadTask.state);
      if (exception == null) {
        return await storageRef.getDownloadURL();
      }
      throw exception;
    } catch (error, st) {
      throw StorageUploadFailedException(error, st);
    }
  }

  Future<String> uploadFileDocument(String fileName, File file) async {
    try {
      final storageRef = _firebaseStorage
          .refFromURL('gs://global-19c96.firebasestorage.app')
          .child(fileName);
      final uploadTask = await storageRef.putFile(file);
      final exception = _mapFailureToException(uploadTask.state);
      if (exception == null) {
        return await storageRef.getDownloadURL();
      }
      throw exception;
    } catch (error, st) {
      throw StorageUploadFailedException(error, st);
    }
  }

  Future<File> downloadFileDocument({
    required String fileName,
    required String? storageFolder,
  }) async {
    if (kIsWeb) {
      throw StorageDownloadErrorException(
        'This method is not supported on web',
        StackTrace.current,
      );
    }
    try {
      final appDocDir = await getApplicationDocumentsDirectory();
      final tempFile = File('${appDocDir.path}/$fileName');

      final storageRef = _firebaseStorage.ref('$storageFolder/$fileName');
      await storageRef.writeToFile(tempFile);

      return tempFile;
    } catch (error, st) {
      throw StorageDownloadErrorException(error, st);
    }
  }

  Future<void> deleteFileDocument(String fileName) async {
    try {
      final storageRef = _firebaseStorage
          .refFromURL('gs://global-19c96.firebasestorage.app')
          .child(fileName);

      await storageRef.delete();
    } catch (error, st) {
      throw StorageDeleteErrorException(error, st);
    }
  }

  FireStorageException? _mapFailureToException(TaskState state) {
    final st = StackTrace.current;
    switch (state) {
      case TaskState.success:
        return null;
      case TaskState.error:
        throw StorageUploadErrorException(state, st);
      case TaskState.canceled:
        throw StorageUploadCancelledException(state, st);
      case TaskState.paused:
        throw StorageUploadPausedException(state, st);
      case TaskState.running:
        throw StorageUploadRunningException(state, st);
    }
  }
}
