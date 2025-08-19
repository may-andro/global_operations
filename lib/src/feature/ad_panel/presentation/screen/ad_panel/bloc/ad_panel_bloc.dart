import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/ad_panel_event.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/ad_panel_state.dart';

class AdPanelBloc extends Bloc<AdPanelEvent, AdPanelState> {
  AdPanelBloc(
    this._updateAdPanelsUseCase,
    this._compressImageUseCase,
    this._uploadAdPanelImageUseCase,
    this._deleteAdPanelImageUseCase,
  ) : super(const AdPanelInitialState()) {
    on<LoadAdPanelsEvent>(_mapLoadAdPanelsEventToState);
    on<EditAdPanelEvent>(_mapEditAdPanelEventToState);
    on<UpdateAdPanelsEvent>(_mapUpdateAdPanelsEventToState);
    on<DeleteImageEvent>(_mapDeleteImageEventToState);
  }

  final UpdateAdPanelsUseCase _updateAdPanelsUseCase;
  final CompressImageUseCase _compressImageUseCase;
  final UploadAdPanelImageUseCase _uploadAdPanelImageUseCase;
  final DeleteAdPanelImageUseCase _deleteAdPanelImageUseCase;

  final List<String> _imagesToDelete = [];

  Future<void> _mapUpdateAdPanelsEventToState(
    UpdateAdPanelsEvent event,
    Emitter<AdPanelState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) return;

    emit(const AdPanelLoadingState());

    try {
      final processResult = await _processAdPanelsWithImages(
        currentState.adPanels,
        emit,
      );

      if (processResult.hasFailures) {
        // Some files failed but others succeeded
        emit(
          AdPanelPartialFailureState(
            successfulPanels: processResult.successfulPanels,
            failedFiles: processResult.failedFiles,
          ),
        );

        // Update with successful panels only
        if (processResult.successfulPanels.isNotEmpty) {
          await _updateAdPanels(processResult.successfulPanels, emit);
        }
      } else {
        // All files processed successfully
        await _updateAdPanels(processResult.successfulPanels, emit);
      }
    } catch (e) {
      emit(AdPanelErrorState('An unexpected error occurred', cause: e));
    }
  }

  Future<_ProcessResult> _processAdPanelsWithImages(
    List<AdPanelEntity> panels,
    Emitter<AdPanelState> emit,
  ) async {
    final successfulPanels = <AdPanelEntity>[];
    final failedFiles = <String>[];

    // Calculate total files for progress tracking
    final totalFiles = _calculateTotalFiles(panels);
    var processedFiles = 0;

    for (final panel in panels) {
      final result = await _processPanelImages(
        panel,
        emit,
        processedFiles,
        totalFiles,
      );

      if (result.panel != null) {
        successfulPanels.add(result.panel!);
      }

      failedFiles.addAll(result.failedFiles);
      processedFiles += result.processedFileCount;
    }

    return _ProcessResult(
      successfulPanels: successfulPanels,
      failedFiles: failedFiles,
    );
  }

  Future<_PanelProcessResult> _processPanelImages(
    AdPanelEntity panel,
    Emitter<AdPanelState> emit,
    int startFileIndex,
    int totalFiles,
  ) async {
    final images = panel.images ?? [];
    final localFiles = images.where((img) => !img.startsWith('http')).toList();
    final urlImages = images.where((img) => img.startsWith('http')).toList();

    if (localFiles.isEmpty) {
      return _PanelProcessResult(
        panel: panel,
        failedFiles: [],
        processedFileCount: 0,
      );
    }

    final successfulUploads = <String>[];
    final failedFiles = <String>[];
    var currentFileIndex = startFileIndex;

    for (final filePath in localFiles) {
      final file = File(filePath);
      final fileName = file.path.split('/').last;

      try {
        // Step 1: Compress image
        emit(
          AdPanelImageCompressionProgressState(
            currentFileIndex: currentFileIndex + 1,
            totalFiles: totalFiles,
            fileName: fileName,
          ),
        );

        final compressResult = await _compressImageUseCase(file);
        final compressedFile = compressResult.fold(
          (failure) =>
              throw Exception('Compression failed: ${failure.message}'),
          (compressed) => compressed,
        );

        // Step 2: Upload compressed image
        emit(
          AdPanelImageUploadProgressState(
            currentFileIndex: currentFileIndex + 1,
            totalFiles: totalFiles,
            fileName: fileName,
          ),
        );

        final uploadResult = await _uploadAdPanelImageUseCase(
          UploadAdPanelImageParams(file: compressedFile, abPanel: panel),
        );

        final uploadedUrl = uploadResult.fold(
          (failure) => throw Exception('Upload failed: ${failure.message}'),
          (url) => url,
        );

        successfulUploads.add(uploadedUrl);

        // Clean up compressed file
        try {
          if (await compressedFile.exists()) {
            await compressedFile.delete();
          }
        } catch (_) {
          // Ignore cleanup errors
        }
      } catch (e) {
        // File processing failed, add to failed list
        failedFiles.add(filePath);
      }

      currentFileIndex++;
    }

    // Create updated panel with successful uploads only
    final newImages = [...urlImages, ...successfulUploads];
    final updatedPanel = panel.copyWith(images: newImages);

    return _PanelProcessResult(
      panel: updatedPanel,
      failedFiles: failedFiles,
      processedFileCount: localFiles.length,
    );
  }

  int _calculateTotalFiles(List<AdPanelEntity> panels) {
    return panels.fold(0, (total, panel) {
      final images = panel.images ?? [];
      final localFiles = images.where((img) => !img.startsWith('http'));
      return total + localFiles.length;
    });
  }

  FutureOr<void> _mapLoadAdPanelsEventToState(
    LoadAdPanelsEvent event,
    Emitter<AdPanelState> emit,
  ) {
    emit(const AdPanelLoadingState());

    // Sort panels by objectFaceId
    final sortedPanels = List<AdPanelEntity>.from(event.adPanels)
      ..sort((a, b) => a.faceNumber.compareTo(b.faceNumber));

    emit(AdPanelsLoadedState(adPanels: sortedPanels, hasBeenEdited: false));
  }

  FutureOr<void> _mapEditAdPanelEventToState(
    EditAdPanelEvent event,
    Emitter<AdPanelState> emit,
  ) {
    final currentState = state;
    if (currentState is AdPanelsLoadedState) {
      final updatedPanels = List<AdPanelEntity>.from(currentState.adPanels);
      updatedPanels[event.index] = event.updatedPanel;
      emit(AdPanelsLoadedState(adPanels: updatedPanels, hasBeenEdited: true));
    }
  }

  Future<void> _updateAdPanels(
    List<AdPanelEntity> adPanels,
    Emitter<AdPanelState> emit,
  ) async {
    emit(const AdPanelUpdatingPanelsState());

    final deletedFiles = <String>[];

    for (final fileUrl in _imagesToDelete) {
      await _deleteAdPanelImageUseCase(fileUrl);
      deletedFiles.add(fileUrl);
    }
    _imagesToDelete.removeWhere((url) => deletedFiles.contains(url));

    final updateResult = await _updateAdPanelsUseCase(adPanels);

    updateResult.fold((failure) => emit(AdPanelUpdateErrorState(failure)), (_) {
      emit(const AdPanelSuccessState());
      emit(AdPanelsLoadedState(adPanels: adPanels, hasBeenEdited: false));
    });
  }

  FutureOr<void> _mapDeleteImageEventToState(
    DeleteImageEvent event,
    Emitter<AdPanelState> emit,
  ) {
    _imagesToDelete.add(event.fileUrl);
  }
}

class _ProcessResult {
  _ProcessResult({required this.successfulPanels, required this.failedFiles});

  final List<AdPanelEntity> successfulPanels;
  final List<String> failedFiles;

  bool get hasFailures => failedFiles.isNotEmpty;
}

class _PanelProcessResult {
  _PanelProcessResult({
    this.panel,
    required this.failedFiles,
    required this.processedFileCount,
  });

  final AdPanelEntity? panel;
  final List<String> failedFiles;
  final int processedFileCount;
}
