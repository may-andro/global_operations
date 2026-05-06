import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/bloc/ad_panels_event.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/bloc/ad_panels_state.dart';
import 'package:global_ops/src/feature/feature_toggle/feature_toggle.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:rxdart/rxdart.dart';

class AdPanelsBloc extends Bloc<AdPanelsEvent, AdPanelsState> {
  AdPanelsBloc(
    this._isLocationBasedSearchEnabledStreamUseCase,
    this._adPanelsDbSourcePathStreamUseCase,
    this._isFeatureEnabledUseCase,
  ) : super(AdPanelsInitialState()) {
    on<LoadAdPanelsEvent>(_mapLoadAdPanelsEventToState);
  }

  final IsLocationBasedSearchEnabledStreamUseCase
  _isLocationBasedSearchEnabledStreamUseCase;
  final GetAdPanelsDbSourcePathStreamUseCase _adPanelsDbSourcePathStreamUseCase;
  final IsFeatureEnabledUseCase _isFeatureEnabledUseCase;

  Future<void> _mapLoadAdPanelsEventToState(
    LoadAdPanelsEvent event,
    Emitter<AdPanelsState> emit,
  ) async {
    emit(AdPanelsLoadingState());
    final isLocationFeatureEnabled = await _isLocationFeatureEnabled;

    await emit.forEach<List<dynamic>>(
      Rx.combineLatest2(
        _isLocationBasedSearchEnabledStreamUseCase(),
        _adPanelsDbSourcePathStreamUseCase(),
        (enabled, path) => [enabled, path],
      ),
      onData: (values) {
        final enabled = values[0] as bool?;
        final path = values[1] as String?;
        if (enabled == null || path == null) {
          return AdPanelsLoadingState();
        }
        return AdPanelsLoadedState(enabled && isLocationFeatureEnabled, path);
      },
      onError: (error, _) => AdPanelsErrorState(error.toString()),
    );
  }

  Future<bool> get _isLocationFeatureEnabled async {
    final eitherResult = await _isFeatureEnabledUseCase(Feature.locationSearch);
    return eitherResult.fold((failure) => false, (isEnabled) => isEnabled);
  }
}
