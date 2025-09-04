import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class FeatureToggleState extends Equatable {
  const FeatureToggleState();

  @override
  List<Object?> get props => [];
}

final class FeatureToggleInitialState extends FeatureToggleState {}

final class FeatureToggleLoadingState extends FeatureToggleState {
  const FeatureToggleLoadingState();
}

final class FeatureToggleLoadedState extends FeatureToggleState {
  const FeatureToggleLoadedState({
    required this.featureFlags,
    required this.filteredFeatureFlags,
    this.searchQuery = '',
    this.isGridView = false,
    this.isRestartNeeded = false,
  });

  final List<FeatureFlag> featureFlags;
  final List<FeatureFlag> filteredFeatureFlags;
  final String searchQuery;
  final bool isGridView;
  final bool isRestartNeeded;

  FeatureToggleLoadedState copyWith({
    List<FeatureFlag>? featureFlags,
    List<FeatureFlag>? filteredFeatureFlags,
    String? searchQuery,
    bool? isSortedAlphabetically,
    bool? isGridView,
    bool? isRestartNeeded,
  }) {
    return FeatureToggleLoadedState(
      featureFlags: featureFlags ?? this.featureFlags,
      filteredFeatureFlags: filteredFeatureFlags ?? this.filteredFeatureFlags,
      searchQuery: searchQuery ?? this.searchQuery,
      isGridView: isGridView ?? this.isGridView,
      isRestartNeeded: isRestartNeeded ?? this.isRestartNeeded,
    );
  }

  @override
  List<Object?> get props => [
    featureFlags,
    filteredFeatureFlags,
    searchQuery,
    isGridView,
    isRestartNeeded,
  ];
}

/// Error state
final class FeatureToggleErrorState extends FeatureToggleState {
  const FeatureToggleErrorState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}

/*class FeatureToggleState extends Equatable {
  const FeatureToggleState({
    required this.scrollController,
    required this.searchFocusNode,
    required this.searchTextEditingController,
    this.viewState = DSViewState.loading,
    this.featureFlags,
    this.searchTerm,
    this.isGrid = true,
    this.isRestartNeeded = false,
    this.isSearchFieldVisible = false,
  });

  final ScrollController scrollController;
  final FocusNode searchFocusNode;
  final TextEditingController searchTextEditingController;
  final DSViewState viewState;
  final List<FeatureFlag>? featureFlags;
  final String? searchTerm;
  final bool isGrid;
  final bool isRestartNeeded;
  final bool isSearchFieldVisible;

  @override
  List<Object?> get props => [
    viewState,
    featureFlags,
    searchTerm,
    isGrid,
    isRestartNeeded,
    isSearchFieldVisible,
  ];

  FeatureToggleState copyWith({
    DSViewState? viewState,
    List<FeatureFlag>? featureFlags,
    String? searchTerm,
    bool? isGrid,
    bool? isRestartNeeded,
    bool? isSearchFieldVisible,
  }) {
    return FeatureToggleState(
      scrollController: scrollController,
      searchFocusNode: searchFocusNode,
      searchTextEditingController: searchTextEditingController,
      viewState: viewState ?? this.viewState,
      featureFlags: featureFlags ?? this.featureFlags,
      searchTerm: searchTerm ?? this.searchTerm,
      isGrid: isGrid ?? this.isGrid,
      isRestartNeeded: isRestartNeeded ?? this.isRestartNeeded,
      isSearchFieldVisible: isSearchFieldVisible ?? this.isSearchFieldVisible,
    );
  }

  List<FeatureFlag>? get filteredFeatureFlags {
    final searchedTerm = (searchTerm ?? searchTextEditingController.text)
        .toLowerCase()
        .trim();
    return featureFlags
        ?.where(
          (featureFlag) =>
              featureFlag.feature.title.toLowerCase().contains(searchedTerm),
        )
        .toList();
  }
}*/
