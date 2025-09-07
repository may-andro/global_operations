import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/feature_toggle/feature_toggle.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:global_ops/src/feature/setting/presentation/screen/bloc/setting_event.dart';
import 'package:global_ops/src/feature/setting/presentation/screen/bloc/setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc(
    this._updateLocationBasedSearchEnabledUseCase,
    this._isLocationBasedSearchEnabledStreamUseCase,
    this._isFeatureEnabledUseCase,
  ) : super(const SettingInitialState()) {
    on<LoadSettingsEvent>(_mapLoadSettingsEventToState);
    on<ToggleLocationBasedSearchEvent>(
      _mapToggleLocationBasedSearchEventToState,
    );
  }

  final IsLocationBasedSearchEnabledStreamUseCase
  _isLocationBasedSearchEnabledStreamUseCase;
  final UpdateLocationBasedSearchEnabledUseCase
  _updateLocationBasedSearchEnabledUseCase;
  final IsFeatureEnabledUseCase _isFeatureEnabledUseCase;

  Future<void> _mapLoadSettingsEventToState(
    LoadSettingsEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(const SettingLoadingState());
    final isLocationFeatureEnabled = await _isLocationFeatureEnabled;
    await emit.forEach<bool?>(
      _isLocationBasedSearchEnabledStreamUseCase(),
      onData: (enabled) {
        return SettingLoadedState(
          locationBasedSearch: enabled ?? true,
          isLocationEnabled: isLocationFeatureEnabled,
        );
      },
      onError: (error, _) => SettingErrorState(error.toString()),
    );
  }

  FutureOr<void> _mapToggleLocationBasedSearchEventToState(
    ToggleLocationBasedSearchEvent event,
    Emitter<SettingState> emit,
  ) async {
    await _updateLocationBasedSearchEnabledUseCase(event.enabled);

    final currentState = state;
    if (currentState is SettingLoadedState) {
      emit(currentState.copyWith(locationBasedSearch: event.enabled));
    }
  }

  Future<bool> get _isLocationFeatureEnabled async {
    final eitherResult = await _isFeatureEnabledUseCase(Feature.locationSearch);
    return eitherResult.fold((failure) => false, (isEnabled) => isEnabled);
  }
}
