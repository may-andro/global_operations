import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

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

class AdPanelsLoadedState extends AdPanelState {
  const AdPanelsLoadedState({
    required this.adPanels,
    required this.hasBeenEdited,
  });

  final bool hasBeenEdited;
  final List<AdPanelEntity> adPanels;

  @override
  List<Object?> get props => [adPanels, hasBeenEdited];
}

class AdPanelErrorState extends AdPanelState {
  const AdPanelErrorState(this.message, {this.cause});

  final String message;
  final Object? cause;

  @override
  List<Object?> get props => [message, cause];
}

class AdPanelUploadErrorState extends AdPanelState {
  const AdPanelUploadErrorState(this.failure);

  final UploadAdPanelImageFailure failure;

  @override
  List<Object?> get props => [failure];
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
  const AdPanelImageCompressionProgressState({
    required this.currentFileIndex,
    required this.totalFiles,
    required this.fileName,
  });

  final int currentFileIndex;
  final int totalFiles;
  final String fileName;

  @override
  List<Object?> get props => [currentFileIndex, totalFiles, fileName];
}

class AdPanelImageUploadProgressState extends AdPanelState {
  const AdPanelImageUploadProgressState({
    required this.currentFileIndex,
    required this.totalFiles,
    required this.fileName,
  });

  final int currentFileIndex;
  final int totalFiles;
  final String fileName;

  @override
  List<Object?> get props => [currentFileIndex, totalFiles, fileName];
}

class AdPanelImageDeleteProgressState extends AdPanelState {
  const AdPanelImageDeleteProgressState({required this.fileName});

  final String fileName;

  @override
  List<Object?> get props => [fileName];
}

class AdPanelUpdatingPanelsState extends AdPanelState {
  const AdPanelUpdatingPanelsState();

  @override
  List<Object?> get props => [];
}

class AdPanelPartialFailureState extends AdPanelState {
  const AdPanelPartialFailureState({
    required this.successfulPanels,
    required this.failedFiles,
  });

  final List<AdPanelEntity> successfulPanels;
  final List<String> failedFiles;

  @override
  List<Object?> get props => [successfulPanels, failedFiles];
}
