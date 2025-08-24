import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/proximity_ad_panels_event.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/proximity_ad_panels_exceptions.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/proximity_ad_panels_state.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/proximity_ad_panels_utils.dart';
import 'package:global_ops/src/feature/location/location.dart';

/// Bloc for managing proximity-based ad panels functionality
///
/// This bloc handles:
/// - Loading ad panels within a specified radius
/// - Real-time location updates
/// - Search and filtering operations
/// - Sorting and view type management
/// - Error handling and retry logic
class ProximityAdPanelsBloc
    extends Bloc<ProximityAdPanelsEvent, ProximityAdPanelsState>
    with AdPanelsBusinessLogic, LocationUtilities, ErrorHandling {
  ProximityAdPanelsBloc(this._getAdPanelsWithinDistanceStreamUseCase)
    : super(const AdPanelsInitialState()) {
    _registerEventHandlers();
  }

  // ============================================================================
  // DEPENDENCIES
  // ============================================================================

  final GetAdPanelsWithinDistanceStreamUseCase
  _getAdPanelsWithinDistanceStreamUseCase;

  // ============================================================================
  // PRIVATE STATE
  // ============================================================================

  LocationEntity? _lastLocation;
  AdPanelSortOption _currentSortOption = const DistanceSortOption();
  AdPanelViewType _currentViewType = AdPanelViewType.list;

  // ============================================================================
  // EVENT REGISTRATION
  // ============================================================================

  void _registerEventHandlers() {
    // Data loading events
    on<LoadAdPanelsEvent>(_mapLoadAdPanelsEventToState);
    on<RefreshAdPanelsEvent>(_mapRefreshAdPanelsEventToState);
    on<RetryLoadAdPanelsEvent>(_mapRetryLoadAdPanelsEventToState);

    // Location events
    on<UpdateLocationEvent>(_mapUpdateLocationEventToState);
    on<UpdateSearchRadiusEvent>(_mapUpdateSearchRadiusEventToState);

    // Filtering and search events
    on<UpdateSearchQueryEvent>(_mapUpdateSearchQueryEventToState);
    on<ClearAdPanelsFiltersEvent>(_mapClearAdPanelsFiltersEventToState);
    on<UpdateSortOptionEvent>(_mapUpdateSortOptionEventToState);

    // UI state events
    on<SetAdPanelsViewTypeEvent>(_mapSetAdPanelsViewTypeEventToState);
  }

  // ============================================================================
  // DATA LOADING EVENT HANDLERS
  // ============================================================================

  /// Handles initial loading of ad panels
  Future<void> _mapLoadAdPanelsEventToState(
    LoadAdPanelsEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) async {
    try {
      _lastLocation = event.location;
      emit(const AdPanelsLoadingState());
      await _loadAdPanelsStream(
        location: event.location,
        emit: emit,
        searchQuery: '',
      );
    } catch (error) {
      emit(AdPanelsErrorState.fromError(error));
    }
  }

  /// Handles refreshing of ad panels data
  Future<void> _mapRefreshAdPanelsEventToState(
    RefreshAdPanelsEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) async {
    if (_lastLocation == null) {
      emit(const AdPanelsErrorState(exception: LocationException()));
      return;
    }

    try {
      final searchQuery = _extractSearchQueryFromCurrentState();

      if (state is AdPanelsLoadedState) {
        final currentState = state as AdPanelsLoadedState;
        emit(currentState.copyWith(isRefreshing: true));
      } else {
        emit(const AdPanelsLoadingState());
      }

      await _loadAdPanelsStream(
        location: _lastLocation!,
        emit: emit,
        searchQuery: searchQuery,
      );
    } catch (error) {
      emit(AdPanelsErrorState.fromError(error));
    }
  }

  /// Handles retry after error
  Future<void> _mapRetryLoadAdPanelsEventToState(
    RetryLoadAdPanelsEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) async {
    if (_lastLocation == null) {
      emit(const AdPanelsErrorState(exception: LocationException()));
      return;
    }

    add(LoadAdPanelsEvent(_lastLocation!));
  }

  // ============================================================================
  // LOCATION EVENT HANDLERS
  // ============================================================================

  /// Handles location updates with intelligent merging
  Future<void> _mapUpdateLocationEventToState(
    UpdateLocationEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) async {
    try {
      // Only proceed if we have existing loaded data
      if (state is! AdPanelsLoadedState) {
        add(LoadAdPanelsEvent(event.location));
        return;
      }

      // Only proceed if radius is 5km or less
      if ((state as AdPanelsLoadedState).radiusInKm > defaultSearchRadius) {
        return;
      }

      _lastLocation = event.location;
      final currentState = state as AdPanelsLoadedState;

      await _updateLocationAndMaintainData(
        location: event.location,
        emit: emit,
        currentState: currentState,
      );
    } catch (error) {
      // Keep existing data on location update errors
      if (state is AdPanelsLoadedState) {
        final currentState = state as AdPanelsLoadedState;
        emit(currentState.copyWith(isRefreshing: false));
      }
    }
  }

  /// Handles search radius updates
  Future<void> _mapUpdateSearchRadiusEventToState(
    UpdateSearchRadiusEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) async {
    if (_lastLocation == null) return;

    try {
      final searchQuery = _extractSearchQueryFromCurrentState();

      if (state is AdPanelsLoadedState) {
        final currentState = state as AdPanelsLoadedState;
        emit(
          AdPanelsListLoadingState(
            previousState: currentState.copyWith(radiusInKm: event.radiusInKm),
          ),
        );
      }

      await _loadAdPanelsStream(
        location: _lastLocation!,
        emit: emit,
        searchQuery: searchQuery,
        radiusInKm: event.radiusInKm,
      );
    } catch (error) {
      emit(AdPanelsErrorState.fromError(error));
    }
  }

  // ============================================================================
  // FILTERING AND SEARCH EVENT HANDLERS
  // ============================================================================

  /// Handles search query updates
  void _mapUpdateSearchQueryEventToState(
    UpdateSearchQueryEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) {
    final currentState = state;

    if (currentState is AdPanelsLoadedState) {
      final filteredData = applySearchFilter(
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

  /// Handles clearing of all filters
  void _mapClearAdPanelsFiltersEventToState(
    ClearAdPanelsFiltersEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) {
    if (state is AdPanelsLoadedState) {
      final currentState = state as AdPanelsLoadedState;
      emit(
        currentState.copyWith(
          filteredAdPanelsMap: currentState.adPanelsMap,
          searchQuery: '',
        ),
      );
    }
  }

  /// Handles sort option updates
  void _mapUpdateSortOptionEventToState(
    UpdateSortOptionEvent event,
    Emitter<ProximityAdPanelsState> emit,
  ) {
    if (state is! AdPanelsLoadedState) return;

    final currentState = state as AdPanelsLoadedState;
    _currentSortOption = event.sortOption;

    final sortedMap = sortPanelsMap(
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

  // ============================================================================
  // UI STATE EVENT HANDLERS
  // ============================================================================

  /// Handles view type changes
  void _mapSetAdPanelsViewTypeEventToState(
    SetAdPanelsViewTypeEvent event,
    Emitter<ProximityAdPanelsState> emit,
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

  /// Loads ad panels using stream and handles state transitions
  Future<void> _loadAdPanelsStream({
    required LocationEntity location,
    required Emitter<ProximityAdPanelsState> emit,
    required String searchQuery,
    int? radiusInKm,
  }) async {
    await emit.forEach<List<AdPanelEntity>>(
      _getAdPanelsWithinDistanceStreamUseCase(
        GetAdPanelsWithinDistanceStreamParams(
          location: location,
          radiusInKm: (radiusInKm ?? _currentRadius).toDouble(),
        ),
      ),
      onData: (adPanelsList) => _buildStateFromAdPanelsList(
        adPanelsList: adPanelsList,
        searchQuery: searchQuery,
        radiusInKm: radiusInKm,
      ),
      onError: (error, stackTrace) => AdPanelsErrorState.fromError(error),
    );
  }

  /// Builds appropriate state from ad panels list
  ProximityAdPanelsState _buildStateFromAdPanelsList({
    required List<AdPanelEntity> adPanelsList,
    required String searchQuery,
    int? radiusInKm,
  }) {
    final adPanelsMap = groupPanelsByObjectNumber(adPanelsList);
    final sortedMap = sortPanelsMap(adPanelsMap, _currentSortOption);
    final filteredMap = applySearchFilter(sortedMap, searchQuery);

    return AdPanelsLoadedState(
      adPanelsMap: sortedMap,
      filteredAdPanelsMap: filteredMap,
      searchQuery: searchQuery,
      sortOption: _currentSortOption,
      viewType: _currentViewType,
      radiusInKm: radiusInKm ?? _currentRadius,
    );
  }

  /// Updates location while maintaining existing data
  Future<void> _updateLocationAndMaintainData({
    required LocationEntity location,
    required Emitter<ProximityAdPanelsState> emit,
    required AdPanelsLoadedState currentState,
  }) async {
    emit(currentState.copyWith(isRefreshing: true));

    await emit.forEach<List<AdPanelEntity>>(
      _getAdPanelsWithinDistanceStreamUseCase(
        GetAdPanelsWithinDistanceStreamParams(
          location: location,
          radiusInKm: currentState.radiusInKm.toDouble(),
        ),
      ),
      onData: (newAdPanelsList) => _mergeWithExistingData(
        newAdPanelsList: newAdPanelsList,
        currentState: currentState,
        location: location,
        radiusInKm: currentState.radiusInKm,
      ),
      /*onData: (newAdPanelsList) {
        return _buildStateFromAdPanelsList(
          adPanelsList: newAdPanelsList,
          searchQuery: currentState.searchQuery,
          radiusInKm: currentState.radiusInKm,
        );
      },*/
      onError: (error, stackTrace) {
        return currentState.copyWith(isRefreshing: false);
      },
    );
  }

  /// Merges new data with existing data intelligently
  ProximityAdPanelsState _mergeWithExistingData({
    required List<AdPanelEntity> newAdPanelsList,
    required AdPanelsLoadedState currentState,
    required LocationEntity location,
    required int radiusInKm,
  }) {
    final updatedPanelsMap = updateDistancesForLocation(
      currentState.adPanelsMap,
      location,
      radiusInKm,
    );

    final mergedMap = _getMergeMapFromList(updatedPanelsMap, newAdPanelsList);

    final sortedMap = sortPanelsMap(mergedMap, _currentSortOption);
    final filteredMap = applySearchFilter(sortedMap, currentState.searchQuery);

    return currentState.copyWith(
      adPanelsMap: sortedMap,
      filteredAdPanelsMap: filteredMap,
      isRefreshing: false,
    );
  }

  Map<String, List<AdPanelEntity>> _getMergeMapFromList(
    Map<String, List<AdPanelEntity>> map,
    List<AdPanelEntity> list,
  ) {
    if (list.isNotEmpty) {
      final newPanelsMap = groupPanelsByObjectNumber(list);
      final mergedPanelsMap = Map<String, List<AdPanelEntity>>.from(map);
      for (final entry in newPanelsMap.entries) {
        if (!mergedPanelsMap.containsKey(entry.key)) {
          mergedPanelsMap[entry.key] = entry.value;
        }
      }
      return mergedPanelsMap;
    }

    return groupPanelsByObjectNumber(list);
  }

  /// Extracts search query from current state
  String _extractSearchQueryFromCurrentState() {
    return switch (state) {
      final AdPanelsLoadedState loadedState => loadedState.searchQuery,
      _ => '',
    };
  }

  /// Gets current radius from state or default
  int get _currentRadius {
    return switch (state) {
      final AdPanelsLoadedState loadedState => loadedState.radiusInKm,
      _ => defaultSearchRadius,
    };
  }
}
