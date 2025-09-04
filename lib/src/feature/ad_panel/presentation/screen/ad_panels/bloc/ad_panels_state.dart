import 'package:equatable/equatable.dart';

sealed class AdPanelsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AdPanelsInitialState extends AdPanelsState {}

class AdPanelsLoadingState extends AdPanelsState {}

class AdPanelsLoadedState extends AdPanelsState {
  AdPanelsLoadedState(
    this.isLocationBasedSearchEnabled,
    this.adPanelsDbSourcePath,
  );

  final bool isLocationBasedSearchEnabled;
  final String adPanelsDbSourcePath;

  @override
  List<Object?> get props => [
    isLocationBasedSearchEnabled,
    adPanelsDbSourcePath,
  ];
}

class AdPanelsErrorState extends AdPanelsState {
  AdPanelsErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
