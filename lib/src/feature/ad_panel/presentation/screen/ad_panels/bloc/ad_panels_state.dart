abstract class AdPanelsState {}

class AdPanelsInitialState extends AdPanelsState {}

class AdPanelsLoadingState extends AdPanelsState {}

class AdPanelsLoadedState extends AdPanelsState {
  AdPanelsLoadedState(this.isLocationBasedSearchEnabled);

  final bool isLocationBasedSearchEnabled;
}

class AdPanelsErrorState extends AdPanelsState {
  AdPanelsErrorState(this.message);

  final String message;
}
