import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/file_picker/file_picker.dart';

abstract class AdPanelState extends Equatable {
  const AdPanelState();
}

class AdPanelInitialState extends AdPanelState {
  const AdPanelInitialState();

  @override
  List<Object?> get props => [];
}

class AdPanelLoadingState extends AdPanelState {
  const AdPanelLoadingState();

  @override
  List<Object?> get props => [];
}

class AdPanelErrorState extends AdPanelState {
  const AdPanelErrorState(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}

class AdPanelsLoadedState extends AdPanelState {
  const AdPanelsLoadedState({
    required this.adPanels,
    required this.hasBeenEdited,
    required this.filesToUpload,
    required this.filesToDelete,
    required this.rawFilesToUpload,
  });

  AdPanelsLoadedState copyWith({
    List<AdPanelEntity>? adPanels,
    bool? hasBeenEdited,
    Map<String, List<File>>? filesToUpload,
    Map<String, List<Uint8List>>? rawFilesToUpload,
    Map<String, List<String>>? filesToDelete,
  }) {
    return AdPanelsLoadedState(
      adPanels: adPanels ?? this.adPanels,
      hasBeenEdited: hasBeenEdited ?? this.hasBeenEdited,
      filesToUpload: filesToUpload ?? this.filesToUpload,
      filesToDelete: filesToDelete ?? this.filesToDelete,
      rawFilesToUpload: rawFilesToUpload ?? this.rawFilesToUpload,
    );
  }

  final bool hasBeenEdited;
  final Map<String, List<File>> filesToUpload;
  final Map<String, List<Uint8List>> rawFilesToUpload;
  final Map<String, List<String>> filesToDelete;
  final List<AdPanelEntity> adPanels;

  @override
  List<Object?> get props => [
    adPanels,
    hasBeenEdited,
    filesToUpload,
    rawFilesToUpload,
    filesToDelete,
  ];
}

class AdPanelImageUploadProgressState extends AdPanelState {
  const AdPanelImageUploadProgressState({
    required this.currentFileIndex,
    required this.totalFiles,
  });

  final int currentFileIndex;
  final int totalFiles;

  @override
  List<Object?> get props => [currentFileIndex, totalFiles];
}

class AdPanelUploadErrorState extends AdPanelState {
  const AdPanelUploadErrorState({
    this.uploadImageFileFailure,
    this.uploadRawImageFailure,
  });

  final UploadImageFileFailure? uploadImageFileFailure;
  final UploadRawImageFailure? uploadRawImageFailure;

  @override
  List<Object?> get props => [uploadImageFileFailure, uploadRawImageFailure];
}

class AdPanelUpdatingPanelsState extends AdPanelState {
  const AdPanelUpdatingPanelsState();

  @override
  List<Object?> get props => [];
}

class AdPanelUpdateErrorState extends AdPanelState {
  const AdPanelUpdateErrorState(this.failure);

  final UpdateAdPanelsFailure failure;

  @override
  List<Object?> get props => [failure];
}

class AdPanelSuccessState extends AdPanelState {
  const AdPanelSuccessState();

  @override
  List<Object?> get props => [];
}

class AdPanelImageCompressionProgressState extends AdPanelState {
  const AdPanelImageCompressionProgressState();

  @override
  List<Object?> get props => [];
}

class DismissAdPanelImageCompressionProgressState extends AdPanelState {
  const DismissAdPanelImageCompressionProgressState();

  @override
  List<Object?> get props => [];
}

class AdPanelImageCompressionErrorState extends AdPanelState {
  const AdPanelImageCompressionErrorState({
    this.filePickerFailure,
    this.imagePickerFailure,
  });

  final FilePickerFailure? filePickerFailure;
  final ImagePickerFailure? imagePickerFailure;

  @override
  List<Object?> get props => [filePickerFailure, imagePickerFailure];
}
