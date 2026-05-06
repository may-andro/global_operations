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

/// Success state with data
final class AdPanelsLoadedState extends ProximityAdPanelsState {
  const AdPanelsLoadedState({
    required this.adPanelsMap,
    required this.filteredAdPanelsMap,
    this.searchQuery = '',
    this.isRefreshing = false,
    this.viewType = AdPanelViewType.list,
    this.radiusInKm = defaultSearchRadius,
    this.isAdPanelDetailEnabled = false,
    this.isGoogleMapViewAvailable = false,
    this.isSortButtonAvailable = false,
    this.isSearchFieldAvailable = false,
    this.sortOption,
  });

  final Map<String, List<AdPanelEntity>> adPanelsMap;
  final Map<String, List<AdPanelEntity>> filteredAdPanelsMap;
  final String searchQuery;
  final bool isRefreshing;
  final AdPanelViewType viewType;
  final AdPanelSortOption? sortOption;
  final int radiusInKm;
  final bool isAdPanelDetailEnabled;
  final bool isGoogleMapViewAvailable;
  final bool isSortButtonAvailable;
  final bool isSearchFieldAvailable;

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
    bool? isAdPanelDetailEnabled,
    bool? isGoogleMapViewAvailable,
    bool? isSortButtonAvailable,
    bool? isSearchFieldAvailable,
  }) {
    return AdPanelsLoadedState(
      adPanelsMap: adPanelsMap ?? this.adPanelsMap,
      filteredAdPanelsMap: filteredAdPanelsMap ?? this.filteredAdPanelsMap,
      searchQuery: searchQuery ?? this.searchQuery,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      viewType: viewType ?? this.viewType,
      sortOption: sortOption ?? this.sortOption,
      radiusInKm: radiusInKm ?? this.radiusInKm,
      isAdPanelDetailEnabled:
          isAdPanelDetailEnabled ?? this.isAdPanelDetailEnabled,
      isGoogleMapViewAvailable:
          isGoogleMapViewAvailable ?? this.isGoogleMapViewAvailable,
      isSortButtonAvailable:
          isSortButtonAvailable ?? this.isSortButtonAvailable,
      isSearchFieldAvailable:
          isSearchFieldAvailable ?? this.isSearchFieldAvailable,
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
    isAdPanelDetailEnabled,
    isGoogleMapViewAvailable,
    isSortButtonAvailable,
    isSearchFieldAvailable,
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
