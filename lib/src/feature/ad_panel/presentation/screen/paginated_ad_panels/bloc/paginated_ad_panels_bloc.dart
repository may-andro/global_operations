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
    on<LoadAdPanelsEvent>(_mapLoadAdPanelsEventToState);
    on<LoadMoreAdPanelsEvent>(_mapLoadMoreAdPanelsEventToState);
    on<RefreshAdPanelsEvent>(_mapRefreshAdPanelsEventToState);
    on<UpdateSearchQueryEvent>(_mapUpdateSearchQueryEventToState);
    on<ClearAdPanelsFiltersEvent>(_mapClearAdPanelsFiltersEventToState);
    on<RetryLoadAdPanelsEvent>(_mapRetryLoadAdPanelsEventToState);
    on<SetAdPanelsViewTypeEvent>(_mapSetAdPanelsViewTypeEventToState);
    on<UpdateSortOptionEvent>(_mapUpdateSortOptionEventToState);
  }

  final GetAdPanelsUseCase _getAdPanelsUseCase;

  AdPanelSortOption _currentSortOption = const LastEditedSortOption();
  AdPanelViewType _currentViewType = AdPanelViewType.list;

  Future<void> _mapLoadAdPanelsEventToState(
    LoadAdPanelsEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    emit(const AdPanelsLoadingState());
    await _loadAndHandleAdPanels(emit, searchQuery: '');
  }

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

  void _mapUpdateSearchQueryEventToState(
    UpdateSearchQueryEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) {
    final currentState = state;
    if (currentState is AdPanelsLoadedState) {
      final filteredData = _applyFiltersMap(
        currentState.adPanelsMap,
        event.query,
      );
      emit(
        currentState.copyWith(
          filteredAdPanelsMap: filteredData,
          searchQuery: event.query,
        ),
      );
    }
  }

  void _mapClearAdPanelsFiltersEventToState(
    ClearAdPanelsFiltersEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) {
    final currentState = state;
    if (currentState is AdPanelsLoadedState) {
      emit(
        currentState.copyWith(
          filteredAdPanelsMap: currentState.adPanelsMap,
          searchQuery: '',
        ),
      );
    }
  }

  Future<void> _mapRetryLoadAdPanelsEventToState(
    RetryLoadAdPanelsEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) async {
    add(const LoadAdPanelsEvent());
  }

  void _mapSetAdPanelsViewTypeEventToState(
    SetAdPanelsViewTypeEvent event,
    Emitter<PaginatedAdPanelsState> emit,
  ) {
    final currentState = state;
    _currentViewType = event.viewType;
    if (currentState is AdPanelsLoadedState) {
      emit(currentState.copyWith(viewType: event.viewType));
    } else if (currentState is AdPanelsInitialState) {
      emit(const AdPanelsInitialState());
    } else if (currentState is AdPanelsLoadingState) {
      emit(const AdPanelsLoadingState());
    } else if (currentState is AdPanelsErrorState) {
      emit(AdPanelsErrorState(message: currentState.message));
    } else if (currentState is AdPanelsEmptyState) {
      emit(const AdPanelsEmptyState());
    }
  }

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
      GetAdPanelsParams(page: nextPage),
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
        final filteredData = _applyFiltersMap(
          adPanelsMap,
          currentState.searchQuery,
        );
        final hasMoreData = newAdPanels.length >= adPanelPaginationPageSize;
        emit(
          currentState.copyWith(
            adPanelsMap: adPanelsMap,
            filteredAdPanelsMap: filteredData,
            isLoadingMore: false,
            hasMoreData: hasMoreData,
            currentPage: nextPage,
          ),
        );
      },
    );
  }

  Future<void> _loadAndHandleAdPanels(
    Emitter<PaginatedAdPanelsState> emit, {
    required String searchQuery,
  }) async {
    final adPanelsEither = await _getAdPanelsUseCase(
      const GetAdPanelsParams(refresh: true),
    );
    adPanelsEither.fold(
      (failure) {
        emit(AdPanelsErrorState(message: _getErrorMessage(failure)));
      },
      (adPanels) {
        if (adPanels.isEmpty) {
          emit(const AdPanelsEmptyState());
        } else {
          final adPanelsMap = _groupPanelsByObjectNumber(adPanels);
          final sortedMap = _sortPanelsMap(adPanelsMap, _currentSortOption);
          final filteredMap = _applyFiltersMap(sortedMap, searchQuery);
          final hasMoreData = adPanels.length >= adPanelPaginationPageSize;
          emit(
            AdPanelsLoadedState(
              adPanelsMap: sortedMap,
              filteredAdPanelsMap: filteredMap,
              searchQuery: searchQuery,
              sortOption: _currentSortOption,
              viewType: _currentViewType,
              hasMoreData: hasMoreData,
            ),
          );
        }
      },
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

  Map<String, List<AdPanelEntity>> _applyFiltersMap(
    Map<String, List<AdPanelEntity>> adPanelsMap,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) return adPanelsMap;
    final query = searchQuery.toLowerCase().trim();
    final filtered = <String, List<AdPanelEntity>>{};
    adPanelsMap.forEach((key, panels) {
      final filteredPanels = panels.where((panel) {
        return panel.objectNumber.toLowerCase().contains(query) ||
            panel.street.toLowerCase().contains(query) ||
            panel.campaign.toLowerCase().contains(query);
      }).toList();
      if (filteredPanels.isNotEmpty) {
        filtered[key] = filteredPanels;
      }
    });
    return filtered;
  }

  /// Convert error to user-friendly message
  String _getErrorMessage(dynamic error) {
    // TODO: Implement proper error handling based on error types
    if (error.toString().contains('network')) {
      return 'Network error. Please check your connection.';
    } else if (error.toString().contains('timeout')) {
      return 'Request timed out. Please try again.';
    } else {
      return 'An unexpected error occurred. Please try again.';
    }
  }
}
