import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/ad_panel_bloc_utils.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/ad_panel_event.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/ad_panel_state.dart';
import 'package:global_ops/src/feature/file_picker/file_picker.dart';
import 'package:log_reporter/log_reporter.dart';

class AdPanelBloc extends Bloc<AdPanelEvent, AdPanelState>
    with AdPanelBusinessLogic {
  AdPanelBloc(
    this.updateAdPanelsUseCase,
    this.uploadImageFileUseCase,
    this.uploadRawImageUseCase,
    this.deleteAdPanelImageUseCase,
    this._imagePickerUseCase,
    this._filePickerUseCase,
    this.logReporter,
  ) : super(const AdPanelInitialState()) {
    on<LoadAdPanelsEvent>(_mapLoadAdPanelsEventToState);
    on<EditAdPanelEvent>(_mapEditAdPanelEventToState);
    on<UpdateAdPanelsEvent>(_mapUpdateAdPanelsEventToState);
    on<DeleteImageEvent>(_mapDeleteImageEventToState);
    on<PickImageFileOnWebEvent>(_mapPickImageFileOnWebEventToState);
    on<PickImageFileOnMobileEvent>(_mapPickImageFileOnMobileEventToState);
  }

  @override
  final UpdateAdPanelsUseCase updateAdPanelsUseCase;
  @override
  final UploadImageFileUseCase uploadImageFileUseCase;
  @override
  final UploadRawImageUseCase uploadRawImageUseCase;
  @override
  final DeleteAdPanelImageUseCase deleteAdPanelImageUseCase;
  final ImagePickerUseCase _imagePickerUseCase;
  final FilePickerUseCase _filePickerUseCase;
  @override
  final LogReporter logReporter;

  Future<void> _mapUpdateAdPanelsEventToState(
    UpdateAdPanelsEvent event,
    Emitter<AdPanelState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) return;

    emit(const AdPanelLoadingState());

    final filePathsToUpload = currentState.filesToUpload;
    final rawFilesToUpload = currentState.rawFilesToUpload;
    final panels = List<AdPanelEntity>.from(currentState.adPanels);
    final successfulPanels = <AdPanelEntity>[];

    for (final adPanel in panels) {
      final key = adPanel.key;
      final updatedAdPanel = await processAdPanelImages(
        adPanel: adPanel,
        emit: emit,
        filesToUpload: List<File>.from(filePathsToUpload[key] ?? []),
        onSuccessfulFileUpload: (file) {
          filePathsToUpload[key]?.remove(file);
        },
        rawFilesToUpload: List<Uint8List>.from(rawFilesToUpload[key] ?? []),
        onSuccessfulRawFileUpload: (file) {
          rawFilesToUpload[key]?.remove(file);
        },
      );
      successfulPanels.add(updatedAdPanel);
    }

    // Delete files that are marked for deletion
    await deleteFiles(currentState.filesToDelete);

    // Update the state with successful panels
    await updateAdPanels(successfulPanels, emit);
  }

  FutureOr<void> _mapLoadAdPanelsEventToState(
    LoadAdPanelsEvent event,
    Emitter<AdPanelState> emit,
  ) {
    emit(const AdPanelLoadingState());

    // Sort panels by objectFaceId
    final sortedPanels = List<AdPanelEntity>.from(event.adPanels)
      ..sort((a, b) => a.faceNumber.compareTo(b.faceNumber));

    emit(
      AdPanelsLoadedState(
        adPanels: sortedPanels,
        hasBeenEdited: false,
        filesToUpload: const {},
        filesToDelete: const {},
        rawFilesToUpload: const {},
      ),
    );
  }

  FutureOr<void> _mapEditAdPanelEventToState(
    EditAdPanelEvent event,
    Emitter<AdPanelState> emit,
  ) {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) {
      return null;
    }

    final updatedPanels = List<AdPanelEntity>.from(currentState.adPanels);
    updatedPanels[event.index] = event.updatedPanel;
    emit(currentState.copyWith(adPanels: updatedPanels, hasBeenEdited: true));
  }

  FutureOr<void> _mapDeleteImageEventToState(
    DeleteImageEvent event,
    Emitter<AdPanelState> emit,
  ) {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) {
      return null;
    }

    final adPanel = event.adPanel;
    final key = adPanel.key;

    // File urls are uploaded files in firebase storage
    if (event.url case final String url) {
      final filesToDelete = List<String>.from(
        currentState.filesToDelete[key] ?? [],
      );
      filesToDelete.add(url);

      final updatedFilesToDelete = Map<String, List<String>>.from(
        currentState.filesToDelete,
      );
      updatedFilesToDelete[key] = filesToDelete;

      emit(
        currentState.copyWith(
          filesToDelete: updatedFilesToDelete,
          hasBeenEdited: true,
        ),
      );

      final updatedPanel = adPanel.copyWith(
        images: List<String>.from(adPanel.images ?? [])..remove(url),
      );
      add(EditAdPanelEvent(event.index, updatedPanel));
    }

    // Local file which is not uploaded yet
    if (event.file case final File file) {
      final filesToUpload = List<File>.from(
        currentState.filesToUpload[key] ?? [],
      );
      filesToUpload.remove(file);

      final updatedFilesToUpload = Map<String, List<File>>.from(
        currentState.filesToUpload,
      );
      updatedFilesToUpload[key] = filesToUpload;
      emit(
        currentState.copyWith(
          filesToUpload: updatedFilesToUpload,
          hasBeenEdited: true,
        ),
      );
    }

    // Local raw file which is not uploaded yet
    if (event.rawFile case final Uint8List rawFile) {
      final rawFilesToUpload = List<Uint8List>.from(
        currentState.rawFilesToUpload[key] ?? [],
      );
      rawFilesToUpload.remove(rawFile);

      final updatedRawFilesToUpload = Map<String, List<Uint8List>>.from(
        currentState.rawFilesToUpload,
      );
      updatedRawFilesToUpload[key] = rawFilesToUpload;
      emit(
        currentState.copyWith(
          rawFilesToUpload: updatedRawFilesToUpload,
          hasBeenEdited: true,
        ),
      );
    }
  }

  FutureOr<void> _mapPickImageFileOnWebEventToState(
    PickImageFileOnWebEvent event,
    Emitter<AdPanelState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) {
      return null;
    }

    emit(const AdPanelImageCompressionProgressState());
    emit(currentState);

    final eitherResult = await _filePickerUseCase();
    emit(const DismissAdPanelImageCompressionProgressState());
    eitherResult.fold(
      (failure) {
        emit(AdPanelImageCompressionErrorState(filePickerFailure: failure));
        emit(currentState);
      },
      (bytes) {
        final key = event.adPanel.key;
        final rawFilesToUpload = List<Uint8List>.from(
          currentState.rawFilesToUpload[key] ?? [],
        )..add(bytes);
        final updatedRawFilesToUpload = Map<String, List<Uint8List>>.from(
          currentState.rawFilesToUpload,
        );
        updatedRawFilesToUpload[key] = rawFilesToUpload;

        emit(
          currentState.copyWith(
            rawFilesToUpload: updatedRawFilesToUpload,
            hasBeenEdited: true,
          ),
        );
      },
    );
  }

  FutureOr<void> _mapPickImageFileOnMobileEventToState(
    PickImageFileOnMobileEvent event,
    Emitter<AdPanelState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) {
      return null;
    }

    emit(const AdPanelImageCompressionProgressState());
    emit(currentState);

    final eitherResult = await _imagePickerUseCase(event.imagePickerSource);
    emit(const DismissAdPanelImageCompressionProgressState());
    eitherResult.fold(
      (failure) {
        emit(AdPanelImageCompressionErrorState(imagePickerFailure: failure));
        emit(currentState);
      },
      (file) {
        final filesToUpload = List<File>.from(
          currentState.filesToUpload[event.adPanel.key] ?? [],
        )..add(file);
        final updatedFilesToUpload = Map<String, List<File>>.from(
          currentState.filesToUpload,
        );
        updatedFilesToUpload[event.adPanel.key] = filesToUpload;

        emit(
          currentState.copyWith(
            filesToUpload: updatedFilesToUpload,
            hasBeenEdited: true,
          ),
        );
      },
    );
  }
}
