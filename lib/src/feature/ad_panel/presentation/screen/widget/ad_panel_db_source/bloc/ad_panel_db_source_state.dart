import 'package:equatable/equatable.dart';

sealed class AdPanelDbSourceState extends Equatable {
  const AdPanelDbSourceState();
}

class AdPanelDbSourceLoadingState extends AdPanelDbSourceState {
  const AdPanelDbSourceLoadingState();

  @override
  List<Object?> get props => [];
}

class AdPanelDbSourceLoadedState extends AdPanelDbSourceState {
  const AdPanelDbSourceLoadedState({
    required this.sources,
    required this.selectedSource,
  });

  final List<String> sources;
  final String selectedSource;

  AdPanelDbSourceLoadedState copyWith({
    List<String>? sources,
    String? selectedSource,
  }) {
    return AdPanelDbSourceLoadedState(
      sources: sources ?? this.sources,
      selectedSource: selectedSource ?? this.selectedSource,
    );
  }

  @override
  List<Object?> get props => [sources, selectedSource];
}

class AdPanelDbSourceErrorState extends AdPanelDbSourceState {
  const AdPanelDbSourceErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
