import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';

/// Base class for all ad panels states
sealed class PaginatedAdPanelsState extends Equatable {
  const PaginatedAdPanelsState();

  @override
  List<Object?> get props => [];
}

/// Initial state
final class AdPanelsInitialState extends PaginatedAdPanelsState {
  const AdPanelsInitialState();
}

/// Loading state
final class AdPanelsLoadingState extends PaginatedAdPanelsState {
  const AdPanelsLoadingState();
}

/// Success state with data
final class AdPanelsLoadedState extends PaginatedAdPanelsState {
  const AdPanelsLoadedState({
    required this.adPanelsMap,
    required this.filteredAdPanelsMap,
    this.searchQuery = '',
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasMoreData = true,
    this.currentPage = 1,
    this.viewType = AdPanelViewType.list,
    this.isAdPanelDetailEnabled = false,
    this.isGoogleMapViewAvailable = false,
    this.isSortButtonAvailable = false,
    this.isSearchFieldAvailable = false,
    this.sortOption,
    this.filterOption,
  });

  final Map<String, List<AdPanelEntity>> adPanelsMap;
  final Map<String, List<AdPanelEntity>> filteredAdPanelsMap;
  final String searchQuery;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasMoreData;
  final int currentPage;
  final AdPanelViewType viewType;
  final bool isAdPanelDetailEnabled;
  final bool isGoogleMapViewAvailable;
  final bool isSortButtonAvailable;
  final bool isSearchFieldAvailable;
  final AdPanelSortOption? sortOption;
  final AdPanelFilterOption? filterOption;

  /// Check if any filters are applied
  bool get hasActiveFilters => searchQuery.isNotEmpty;

  /// Check if data is empty
  bool get isEmpty => adPanelsMap.isEmpty;

  /// Check if filtered data is empty
  bool get isFilteredEmpty => filteredAdPanelsMap.isEmpty;

  /// Copy with method for immutable updates
  AdPanelsLoadedState copyWith({
    Map<String, List<AdPanelEntity>>? adPanelsMap,
    Map<String, List<AdPanelEntity>>? filteredAdPanelsMap,
    String? searchQuery,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasMoreData,
    int? currentPage,
    AdPanelViewType? viewType,
    AdPanelSortOption? sortOption,
    AdPanelFilterOption? filterOption,
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
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMoreData: hasMoreData ?? this.hasMoreData,
      currentPage: currentPage ?? this.currentPage,
      viewType: viewType ?? this.viewType,
      sortOption: sortOption ?? this.sortOption,
      filterOption: filterOption ?? this.filterOption,
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
    isLoadingMore,
    hasMoreData,
    currentPage,
    viewType,
    sortOption,
    filterOption,
    isAdPanelDetailEnabled,
    isGoogleMapViewAvailable,
    isSortButtonAvailable,
    isSearchFieldAvailable,
  ];
}

/// Error state
final class AdPanelsErrorState extends PaginatedAdPanelsState {
  const AdPanelsErrorState({
    required this.message,
    this.canRetry = true,
    this.previousData,
  });

  final String message;
  final bool canRetry;
  final List<AdPanelEntity>? previousData;

  @override
  List<Object?> get props => [message, canRetry, previousData];
}
