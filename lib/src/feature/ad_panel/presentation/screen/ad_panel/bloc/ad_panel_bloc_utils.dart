import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/ad_panel_state.dart';
import 'package:log_reporter/log_reporter.dart';

mixin AdPanelBusinessLogic {
  UploadImageFileUseCase get uploadImageFileUseCase;

  UploadRawImageUseCase get uploadRawImageUseCase;

  UpdateAdPanelsUseCase get updateAdPanelsUseCase;

  DeleteAdPanelImageUseCase get deleteAdPanelImageUseCase;

  LogReporter get logReporter;

  bool hasFilesUploadedSuccessfully(
    Map<String, List<String>> filePathsToUpload,
    Map<String, List<Uint8List>> rawFilesToUpload,
  ) {
    return filePathsToUpload.values.any((list) => list.isNotEmpty) ||
        rawFilesToUpload.values.any((list) => list.isNotEmpty);
  }

  Future<void> deleteFiles(Map<String, List<String>> filesToDeleteMap) async {
    final filesToDelete = filesToDeleteMap.values
        .expand((list) => list)
        .toList();
    for (final url in filesToDelete) {
      await deleteAdPanelImageUseCase(url);
    }
  }

  Future<void> updateAdPanels(
    List<AdPanelEntity> adPanels,
    Emitter<AdPanelState> emit,
  ) async {
    emit(const AdPanelUpdatingPanelsState());

    final updateResult = await updateAdPanelsUseCase(adPanels);

    updateResult.fold((failure) => emit(AdPanelUpdateErrorState(failure)), (_) {
      emit(const AdPanelSuccessState());
      emit(
        AdPanelsLoadedState(
          adPanels: adPanels,
          hasBeenEdited: false,
          filesToUpload: const {},
          filesToDelete: const {},
          rawFilesToUpload: const {},
        ),
      );
    });
  }

  Future<AdPanelEntity> processAdPanelImages({
    required AdPanelEntity adPanel,
    required Emitter<AdPanelState> emit,
    required List<File> filesToUpload,
    required void Function(File file) onSuccessfulFileUpload,
    required List<Uint8List> rawFilesToUpload,
    required void Function(Uint8List bytes) onSuccessfulRawFileUpload,
  }) async {
    if (filesToUpload.isNotEmpty) {
      final successfulUploads = await _processImageFiles(
        key: adPanel.key,
        emit: emit,
        files: filesToUpload,
        onSuccessfulFileUpload: onSuccessfulFileUpload,
      );
      adPanel = adPanel.copyWith(
        images: [...adPanel.images ?? [], ...successfulUploads],
      );
    }

    if (rawFilesToUpload.isNotEmpty) {
      final successfulUploads = await _processRawImageFiles(
        key: adPanel.key,
        emit: emit,
        rawFiles: rawFilesToUpload,
        onSuccessfulRawFileUpload: onSuccessfulRawFileUpload,
      );
      adPanel = adPanel.copyWith(
        images: [...adPanel.images ?? [], ...successfulUploads],
      );
    }

    return adPanel;
  }

  Future<List<String>> _processImageFiles({
    required String key,
    required List<File> files,
    required Emitter<AdPanelState> emit,
    required void Function(File file) onSuccessfulFileUpload,
  }) async {
    int currentFileIndex = 0;
    final List<String> uploadedFileUrls = [];

    for (final file in files) {
      emit(
        AdPanelImageUploadProgressState(
          currentFileIndex: currentFileIndex + 1,
          totalFiles: files.length,
        ),
      );

      final uploadResult = await uploadImageFileUseCase(
        UploadImageFileParams(
          file: file,
          fileName: '${key}_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );

      final uploadedUrl = uploadResult.fold((failure) {
        emit(AdPanelUploadErrorState(uploadImageFileFailure: failure));
      }, (url) => url);

      if (uploadedUrl == null) continue;

      uploadedFileUrls.add(uploadedUrl);

      // Call the callback function to notify about successful upload
      onSuccessfulFileUpload(file);

      currentFileIndex += 1;
    }

    return uploadedFileUrls;
  }

  Future<List<String>> _processRawImageFiles({
    required String key,
    required List<Uint8List> rawFiles,
    required Emitter<AdPanelState> emit,
    required void Function(Uint8List bytes) onSuccessfulRawFileUpload,
  }) async {
    int currentFileIndex = 0;
    final List<String> uploadedFileUrls = [];

    for (final rawFile in rawFiles) {
      emit(
        AdPanelImageUploadProgressState(
          currentFileIndex: currentFileIndex + 1,
          totalFiles: rawFiles.length,
        ),
      );

      final uploadResult = await uploadRawImageUseCase(
        UploadRawImageParams(
          rawData: rawFile,
          fileName: '${key}_${DateTime.now().millisecondsSinceEpoch}',
        ),
      );

      final uploadedUrl = uploadResult.fold((failure) {
        emit(AdPanelUploadErrorState(uploadRawImageFailure: failure));
      }, (url) => url);

      if (uploadedUrl == null) continue;

      uploadedFileUrls.add(uploadedUrl);

      // Call the callback function to notify about successful upload
      onSuccessfulRawFileUpload(rawFile);

      currentFileIndex += 1;
    }

    return uploadedFileUrls;
  }
}
