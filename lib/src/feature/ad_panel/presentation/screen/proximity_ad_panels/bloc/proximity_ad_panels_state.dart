import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/proximity_ad_panels_exceptions.dart';

const int defaultSearchRadius = 5;

/// Base class for all ad panels states
sealed class ProximityAdPanelsState extends Equatable {
  const ProximityAdPanelsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class AdPanelsInitialState extends ProximityAdPanelsState {
  const AdPanelsInitialState();
}

/// Loading state
final class AdPanelsLoadingState extends ProximityAdPanelsState {
  const AdPanelsLoadingState();
}

/// Loading state for list-only operations (e.g., radius change)
final class AdPanelsListLoadingState extends ProximityAdPanelsState {
  const AdPanelsListLoadingState({required this.previousState});

  final AdPanelsLoadedState previousState;

  @override
  List<Object?> get props => [previousState];
}

/// Success state with data
final class AdPanelsLoadedState extends ProximityAdPanelsState {
  const AdPanelsLoadedState({
    required this.adPanelsMap,
    required this.filteredAdPanelsMap,
    this.searchQuery = '',
    this.isRefreshing = false,
    this.viewType = AdPanelViewType.list,
    this.radiusInKm = defaultSearchRadius,
    this.sortOption,
  });

  /// Factory constructor for creating initial loaded state
  factory AdPanelsLoadedState.initial({
    required Map<String, List<AdPanelEntity>> adPanelsMap,
    AdPanelSortOption? sortOption,
    int? radiusInKm,
  }) {
    return AdPanelsLoadedState(
      adPanelsMap: adPanelsMap,
      filteredAdPanelsMap: adPanelsMap,
      sortOption: sortOption,
      radiusInKm: radiusInKm ?? defaultSearchRadius,
    );
  }

  /// Factory constructor for creating state with search applied
  factory AdPanelsLoadedState.withSearch({
    required Map<String, List<AdPanelEntity>> adPanelsMap,
    required Map<String, List<AdPanelEntity>> filteredAdPanelsMap,
    required String searchQuery,
    AdPanelSortOption? sortOption,
    AdPanelViewType? viewType,
    int? radiusInKm,
  }) {
    return AdPanelsLoadedState(
      adPanelsMap: adPanelsMap,
      filteredAdPanelsMap: filteredAdPanelsMap,
      searchQuery: searchQuery,
      sortOption: sortOption,
      viewType: viewType ?? AdPanelViewType.list,
      radiusInKm: radiusInKm ?? defaultSearchRadius,
    );
  }

  final Map<String, List<AdPanelEntity>> adPanelsMap;
  final Map<String, List<AdPanelEntity>> filteredAdPanelsMap;
  final String searchQuery;
  final bool isRefreshing;
  final AdPanelViewType viewType;
  final AdPanelSortOption? sortOption;
  final int radiusInKm;

  /// Check if any filters are applied
  bool get hasActiveFilters => searchQuery.isNotEmpty;

  /// Check if data is empty
  bool get isEmpty => adPanelsMap.isEmpty;

  /// Check if filtered data is empty
  bool get isFilteredEmpty => filteredAdPanelsMap.isEmpty;

  /// Get total count of all panels
  int get totalPanelsCount =>
      adPanelsMap.values.fold(0, (sum, list) => sum + list.length);

  /// Get count of filtered panels
  int get filteredPanelsCount =>
      filteredAdPanelsMap.values.fold(0, (sum, list) => sum + list.length);

  /// Copy with method for immutable updates
  AdPanelsLoadedState copyWith({
    Map<String, List<AdPanelEntity>>? adPanelsMap,
    Map<String, List<AdPanelEntity>>? filteredAdPanelsMap,
    String? searchQuery,
    bool? isRefreshing,
    AdPanelViewType? viewType,
    AdPanelSortOption? sortOption,
    int? radiusInKm,
  }) {
    return AdPanelsLoadedState(
      adPanelsMap: adPanelsMap ?? this.adPanelsMap,
      filteredAdPanelsMap: filteredAdPanelsMap ?? this.filteredAdPanelsMap,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      viewType: viewType ?? this.viewType,
      sortOption: sortOption ?? this.sortOption,
      radiusInKm: radiusInKm ?? this.radiusInKm,
    );
  }

  @override
  List<Object?> get props => [
    adPanelsMap,
    filteredAdPanelsMap,
    searchQuery,
    isRefreshing,
    viewType,
    sortOption,
    radiusInKm,
  ];
}

/// Error state
final class AdPanelsErrorState extends ProximityAdPanelsState {
  const AdPanelsErrorState({
    required this.exception,
    this.canRetry = true,
    this.previousData,
  });

  /// Factory constructor for creating error state from generic error
  factory AdPanelsErrorState.fromError(
    dynamic error, {
    bool canRetry = true,
    List<AdPanelEntity>? previousData,
  }) {
    ProximityAdPanelsException exception;

    if (error is ProximityAdPanelsException) {
      exception = error;
    } else {
      final errorString = error.toString().toLowerCase();
      if (errorString.contains('network')) {
        exception = const NetworkException();
      } else if (errorString.contains('timeout')) {
        exception = const TimeoutException();
      } else if (errorString.contains('location')) {
        exception = const LocationException();
      } else {
        exception = const UnknownException();
      }
    }

    return AdPanelsErrorState(
      exception: exception,
      canRetry: canRetry,
      previousData: previousData,
    );
  }

  final ProximityAdPanelsException exception;
  final bool canRetry;
  final List<AdPanelEntity>? previousData;

  /// Get user-friendly error message
  String get message => exception.message;

  /// Get error code if available
  String? get errorCode => exception.code;

  @override
  List<Object?> get props => [exception, canRetry, previousData];
}
