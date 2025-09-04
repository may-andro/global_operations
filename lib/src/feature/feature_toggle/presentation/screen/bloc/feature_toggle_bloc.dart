import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/app/restart_app.dart';
import 'package:global_ops/src/feature/feature_toggle/domain/domain.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/feature_toggle_event.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/feature_toggle_state.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/tracking/feature_toggle_tracking_delegate.dart';

class FeatureToggleBloc extends Bloc<FeatureToggleEvent, FeatureToggleState> {
  FeatureToggleBloc(
    this._getFeatureFlagsUseCase,
    this._updateFeatureFlagUseCase,
    this._resetFeatureFlagsUseCase,
    this._trackingDelegate,
  ) : super(FeatureToggleInitialState()) {
    _registerEventHandlers();
  }

  // ============================================================================
  // DEPENDENCIES
  // ============================================================================

  final GetFeatureFlagsUseCase _getFeatureFlagsUseCase;
  final UpdateFeatureFlagUseCase _updateFeatureFlagUseCase;
  final ResetFeatureFlagsUseCase _resetFeatureFlagsUseCase;
  final FeatureToggleTrackingDelegate _trackingDelegate;

  // ============================================================================
  // EVENT REGISTRATION
  // ============================================================================

  void _registerEventHandlers() {
    // Data loading events
    on<LoadFFEvent>(_mapLoadFFEventToState);
    on<ResetFFEvent>(_mapResetFFEventToState);
    on<UpdateFFEvent>(_mapUpdateFFEventToState);

    // Filtering and search events
    on<UpdateSearchQueryEvent>(_mapUpdateSearchQueryEventToState);
    on<ClearSearchQueryEvent>(_mapClearSearchQueryEventToState);

    // UI state events
    on<UpdateListViewTypeEvent>(_mapUpdateListViewTypeEventToState);

    // Navigation events
    on<RestartAppEvent>(_mapRestartAppEventToState);

    // Tracking events
    on<TrackScreenVisibleEvent>(_mapTrackScreenVisibleEventToState);
  }

  // ============================================================================
  // DATA LOADING EVENT HANDLERS
  // ============================================================================

  FutureOr<void> _mapLoadFFEventToState(
    LoadFFEvent event,
    Emitter<FeatureToggleState> emit,
  ) async {
    emit(const FeatureToggleLoadingState());
    await _loadFF(emit);
  }

  FutureOr<void> _mapResetFFEventToState(
    ResetFFEvent event,
    Emitter<FeatureToggleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeatureToggleLoadedState) return;

    emit(const FeatureToggleLoadingState());

    final eitherResult = await _resetFeatureFlagsUseCase();
    await eitherResult.fold(
      (failure) {
        //emit(const FeatureToggleErrorState(message: ''));
      },
      (_) async {
        await _loadFF(
          emit,
          isRestartNeeded: true,
          searchQuery: currentState.searchQuery,
          isGridView: currentState.isGridView,
        );
      },
    );
  }

  FutureOr<void> _mapUpdateFFEventToState(
    UpdateFFEvent event,
    Emitter<FeatureToggleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! FeatureToggleLoadedState) return;

    final eitherResult = await _updateFeatureFlagUseCase(event.featureFlag);
    eitherResult.fold(
      (failure) {
        //emit(state.copyWith(viewState: DSViewState.error));
      },
      (_) {
        final List<FeatureFlag> featureFlags = List.of(
          currentState.featureFlags,
        );

        final index = featureFlags.indexWhere(
          (featureFlag) => featureFlag.feature == event.featureFlag.feature,
        );
        if (index == -1) return;

        featureFlags[index] = event.featureFlag;

        emit(
          currentState.copyWith(
            featureFlags: featureFlags,
            filteredFeatureFlags: _filterFeatureFlags(
              featureFlags,
              currentState.searchQuery,
            ),
            isRestartNeeded: true,
            searchQuery: currentState.searchQuery,
          ),
        );
      },
    );
  }

  // ============================================================================
  // FILTERING AND SEARCH EVENT HANDLERS
  // ============================================================================

  FutureOr<void> _mapUpdateSearchQueryEventToState(
    UpdateSearchQueryEvent event,
    Emitter<FeatureToggleState> emit,
  ) {
    final currentState = state;
    if (currentState is FeatureToggleLoadedState) {
      emit(
        currentState.copyWith(
          filteredFeatureFlags: _filterFeatureFlags(
            currentState.featureFlags,
            event.query,
          ),
          searchQuery: event.query,
        ),
      );
    }
  }

  FutureOr<void> _mapClearSearchQueryEventToState(
    ClearSearchQueryEvent event,
    Emitter<FeatureToggleState> emit,
  ) {
    final currentState = state;
    if (currentState is FeatureToggleLoadedState) {
      emit(
        currentState.copyWith(
          featureFlags: currentState.featureFlags,
          filteredFeatureFlags: _filterFeatureFlags(
            currentState.featureFlags,
            '',
          ),
          searchQuery: '',
        ),
      );
    }
  }

  // ============================================================================
  // UI STATE EVENT HANDLERS
  // ============================================================================

  FutureOr<void> _mapUpdateListViewTypeEventToState(
    UpdateListViewTypeEvent event,
    Emitter<FeatureToggleState> emit,
  ) {
    final currentState = state;
    if (currentState is FeatureToggleLoadedState) {
      emit(currentState.copyWith(isGridView: !currentState.isGridView));
    }
  }

  // ============================================================================
  // APP EVENT HANDLERS
  // ============================================================================

  FutureOr<void> _mapRestartAppEventToState(
    RestartAppEvent event,
    Emitter<FeatureToggleState> emit,
  ) {
    restartAppWithoutInitialization();
  }

  // ============================================================================
  // TRACKING EVENT HANDLERS
  // ============================================================================

  FutureOr<void> _mapTrackScreenVisibleEventToState(
    TrackScreenVisibleEvent event,
    Emitter<FeatureToggleState> emit,
  ) {
    _trackingDelegate.trackScreenView();
  }

  // ============================================================================
  // PRIVATE HELPER METHODS
  // ============================================================================

  Future<void> _loadFF(
    Emitter<FeatureToggleState> emit, {
    String searchQuery = '',
    bool isRestartNeeded = false,
    bool isGridView = false,
  }) async {
    final eitherResult = await _getFeatureFlagsUseCase();
    eitherResult.fold(
      (failure) {
        emit(FeatureToggleErrorState(message: '${failure.message}'));
      },
      (featureFlags) {
        emit(
          FeatureToggleLoadedState(
            featureFlags: featureFlags,
            filteredFeatureFlags: _filterFeatureFlags(
              featureFlags,
              searchQuery,
            ),
            searchQuery: searchQuery,
            isRestartNeeded: isRestartNeeded,
            isGridView: isGridView,
          ),
        );
      },
    );
  }

  List<FeatureFlag> _filterFeatureFlags(
    List<FeatureFlag> featureFlags,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) return featureFlags;

    final query = searchQuery.toLowerCase().trim();
    return featureFlags.where((featureFlag) {
      return featureFlag.feature.title.toLowerCase().contains(query) ||
          featureFlag.feature.key.toLowerCase().contains(query);
    }).toList();
  }
}
