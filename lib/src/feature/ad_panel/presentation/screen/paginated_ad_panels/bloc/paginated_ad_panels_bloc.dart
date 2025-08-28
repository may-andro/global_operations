import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/paginated_ad_panels_event.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/paginated_ad_panels_state.dart';

class PaginatedAdPanelsBloc
    extends Bloc<PaginatedAdPanelsEvent, PaginatedAdPanelsState> {
  PaginatedAdPanelsBloc(this._getAdPanelsUseCase)
    : super(const AdPanelsInitialState()) {
    _registerEventHandlers();
  }

  // ============================================================================
  // DEPENDENCIES
  // ============================================================================

  final GetAdPanelsUseCase _getAdPanelsUseCase;

  // ============================================================================
  // PRIVATE STATE
  // ============================================================================

  AdPanelSortOption _currentSortOption = const LastEditedSortOption();
  AdPanelFilterOption _currentFilterOption = const ObjectNumberFilterOption();
  AdPanelViewType _currentViewType = AdPanelViewType.list;

  // ============================================================================
  // EVENT REGISTRATION
  // ============================================================================

  void _registerEventHandlers() {
    // Data loading events
    on<LoadAdPanelsEvent>(_mapLoadAdPanelsEventToState);
    on<LoadMoreAdPanelsEvent>(_mapLoadMoreAdPanelsEventToState);
    on<RefreshAdPanelsEvent>(_mapRefreshAdPanelsEventToState);
    on<RetryLoadAdPanelsEvent>(_mapRetryLoadAdPanelsEventToState);

    // Filtering and search events
    on<UpdateSearchQueryEvent>(_mapUpdateSearchQueryEventToState);
    on<ClearAdPanelsFiltersEvent>(_mapClearAdPanelsFiltersEventToState);
    on<UpdateSortOptionEvent>(_mapUpdateSortOptionEventToState);
    on<UpdateFilterOptionEvent>(_mapUpdateFilterOptionEventToState);

    // UI state events
    on<SetAdPanelsViewTypeEvent>(_mapSetAdPanelsViewTypeEventToState);
  }

  // ============================================================================
  // DATA LOADING EVENT HANDLERS
  // ============================================================================

  /// Handles initial loading of ad panels
  Future<void> _mapLoadAdPanelsEventToState(
    LoadAdPanelsEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    emit(const AdPanelsLoadingState());
    await _loadAndHandleAdPanels(emit, searchQuery: '');
  }

  /// Handles refreshing of ad panels data
  Future<void> _mapRefreshAdPanelsEventToState(
    RefreshAdPanelsEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    final currentState = state;
    String searchQuery = '';
    if (currentState is AdPanelsLoadedState) {
      emit(currentState.copyWith(isRefreshing: true));
      searchQuery = currentState.searchQuery;
    } else {
      emit(const AdPanelsLoadingState());
    }
    await _loadAndHandleAdPanels(emit, searchQuery: searchQuery);
  }

  /// Handles retry after error
  Future<void> _mapRetryLoadAdPanelsEventToState(
    RetryLoadAdPanelsEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    add(const LoadAdPanelsEvent());
  }

  /// Handles loading more ad panels for pagination
  Future<void> _mapLoadMoreAdPanelsEventToState(
    LoadMoreAdPanelsEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState ||
        currentState.isLoadingMore ||
        !currentState.hasMoreData) {
      return;
    }
    emit(currentState.copyWith(isLoadingMore: true));
    final nextPage = currentState.currentPage + 1;
    final adPanelsEither = await _getAdPanelsUseCase(
      GetAdPanelsParams(
        page: nextPage,
        query: currentState.searchQuery.isNotEmpty == true
            ? currentState.searchQuery
            : null,
        field: _currentFilterOption.key,
        limit: currentState.searchQuery.isEmpty == true
            ? _currentFilterOption.defaultPaginationLimit
            : _currentFilterOption.paginationLimit,
      ),
    );
    adPanelsEither.fold(
      (failure) {
        emit(currentState.copyWith(isLoadingMore: false));
      },
      (newAdPanels) {
        final allAdPanels = [
          ...currentState.adPanelsMap.values.expand((x) => x),
          ...newAdPanels,
        ];
        final adPanelsMap = _groupPanelsByObjectNumber(allAdPanels);
        final sortedMap = _sortPanelsMap(adPanelsMap, _currentSortOption);
        final limit = currentState.searchQuery.isEmpty == true
            ? _currentFilterOption.defaultPaginationLimit
            : _currentFilterOption.paginationLimit;
        final hasMoreData = limit != null && newAdPanels.length >= limit;
        emit(
          currentState.copyWith(
            adPanelsMap: adPanelsMap,
            filteredAdPanelsMap: sortedMap,
            isLoadingMore: false,
            hasMoreData: hasMoreData,
            currentPage: nextPage,
          ),
        );
      },
    );
  }

  // ============================================================================
  // FILTERING AND SEARCH EVENT HANDLERS
  // ============================================================================

  /// Handles search query updates
  Future<void> _mapUpdateSearchQueryEventToState(
    UpdateSearchQueryEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    final currentState = state;
    if (currentState is AdPanelsLoadedState) {
      final searchQuery = event.query;
      if (searchQuery.length < 3 && searchQuery.isNotEmpty) {
        emit(currentState.copyWith(searchQuery: searchQuery));
        return;
      }
      emit(currentState.copyWith(isRefreshing: true, searchQuery: searchQuery));
      await _loadAndHandleAdPanels(emit, searchQuery: searchQuery);
    }
  }

  /// Handles clearing of all filters
  Future<void> _mapClearAdPanelsFiltersEventToState(
    ClearAdPanelsFiltersEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    if (state is AdPanelsLoadedState) {
      final currentState = state as AdPanelsLoadedState;
      emit(currentState.copyWith(isRefreshing: true, searchQuery: ''));
      await _loadAndHandleAdPanels(emit, searchQuery: '');
    }
  }

  /// Handles sort option updates
  void _mapUpdateSortOptionEventToState(
    UpdateSortOptionEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) return;
    _currentSortOption = event.sortOption;
    final sortedMap = _sortPanelsMap(
      currentState.filteredAdPanelsMap,
      _currentSortOption,
    );
    emit(
      currentState.copyWith(
        filteredAdPanelsMap: sortedMap,
        sortOption: _currentSortOption,
      ),
    );
  }

  /// Handles filter option updates
  Future<void> _mapUpdateFilterOptionEventToState(
    UpdateFilterOptionEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    final currentState = state;
    if (currentState is! AdPanelsLoadedState) return;

    _currentFilterOption = event.filterOption;
    emit(
      currentState.copyWith(
        isRefreshing: true,
        filterOption: _currentFilterOption,
      ),
    );
    await _loadAndHandleAdPanels(emit, searchQuery: currentState.searchQuery);
  }

  // ============================================================================
  // UI STATE EVENT HANDLERS
  // ============================================================================

  /// Handles view type changes
  void _mapSetAdPanelsViewTypeEventToState(
    SetAdPanelsViewTypeEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) {
    if (state is AdPanelsLoadedState) {
      final currentState = state as AdPanelsLoadedState;
      _currentViewType = event.viewType;
      emit(currentState.copyWith(viewType: event.viewType));
    }
  }

  // ============================================================================
  // PRIVATE HELPER METHODS
  // ============================================================================

  Future<void> _loadAndHandleAdPanels(
    Emitter<PaginatedAdPanelsState> emit, {
    required String searchQuery,
  }) async {
    final adPanelsEither = await _getAdPanelsUseCase(
      GetAdPanelsParams(
        refresh: true,
        query: searchQuery.isEmpty ? null : searchQuery,
        field: _currentFilterOption.key,
        limit: searchQuery.isEmpty
            ? _currentFilterOption.defaultPaginationLimit
            : _currentFilterOption.paginationLimit,
      ),
    );
    adPanelsEither.fold(
      (failure) {
        emit(AdPanelsErrorState(message: _getErrorMessage(failure)));
      },
      (adPanels) {
        emit(
          _buildStateFromAdPanelsList(
            adPanels: adPanels,
            searchQuery: searchQuery,
          ),
        );
      },
    );
  }

  /// Builds appropriate state from ad panels list
  PaginatedAdPanelsState _buildStateFromAdPanelsList({
    required List<AdPanelEntity> adPanels,
    required String searchQuery,
  }) {
    final adPanelsMap = _groupPanelsByObjectNumber(adPanels);
    final sortedMap = _sortPanelsMap(adPanelsMap, _currentSortOption);
    final limit = searchQuery.isEmpty
        ? _currentFilterOption.defaultPaginationLimit
        : _currentFilterOption.paginationLimit;
    final hasMoreData = limit != null && adPanels.length >= limit;

    return AdPanelsLoadedState(
      adPanelsMap: sortedMap,
      filteredAdPanelsMap: sortedMap,
      searchQuery: searchQuery,
      sortOption: _currentSortOption,
      filterOption: _currentFilterOption,
      viewType: _currentViewType,
      hasMoreData: hasMoreData,
    );
  }

  Map<String, List<AdPanelEntity>> _groupPanelsByObjectNumber(
    List<AdPanelEntity> panels,
  ) {
    final map = <String, List<AdPanelEntity>>{};
    for (final panel in panels) {
      map.putIfAbsent(panel.objectNumber, () => []).add(panel);
    }
    return map;
  }

  Map<String, List<AdPanelEntity>> _sortPanelsMap(
    Map<String, List<AdPanelEntity>> panelsMap,
    AdPanelSortOption sortOption,
  ) {
    final entries = panelsMap.entries.toList();
    switch (sortOption) {
      case final StreetSortOption _:
        entries.sort(
          (a, b) => a.value.first.street.compareTo(b.value.first.street),
        );
      case final ObjectNumberSortOption _:
        entries.sort(
          (a, b) =>
              a.value.first.objectNumber.compareTo(b.value.first.objectNumber),
        );
      case final LastEditedSortOption _:
        entries.sort((a, b) {
          final aEdited = a.value.any((panel) => panel.hasBeenEdited);
          final bEdited = b.value.any((panel) => panel.hasBeenEdited);
          if (aEdited == bEdited) {
            // fallback to objectNumber sort if both are same
            return a.value.first.objectNumber.compareTo(
              b.value.first.objectNumber,
            );
          }
          return aEdited ? -1 : 1; // edited first
        });
      default:
        return panelsMap;
    }
    return {for (final entry in entries) entry.key: entry.value};
  }

  /// Convert error to user-friendly message
  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('network')) {
      return 'Network error. Please check your connection.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
