import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:global_ops/src/feature/setting/presentation/screen/bloc/setting_event.dart';
import 'package:global_ops/src/feature/setting/presentation/screen/bloc/setting_state.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc(
    this._updateLocationBasedSearchEnabledUseCase,
    this._isLocationBasedSearchEnabledStreamUseCase,
  ) : super(SettingInitialState()) {
    on<LoadSettingsEvent>(_mapLoadSettingsEventToState);
    on<ChangeLanguageEvent>(_mapChangeLanguageEventToState);
    on<ToggleLocationBasedSearchEvent>(
      _mapToggleLocationBasedSearchEventToState,
    );
  }

  final IsLocationBasedSearchEnabledStreamUseCase
  _isLocationBasedSearchEnabledStreamUseCase;
  final UpdateLocationBasedSearchEnabledUseCase
  _updateLocationBasedSearchEnabledUseCase;

  Future<void> _mapLoadSettingsEventToState(
    LoadSettingsEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(SettingInitialState());
    await emit.forEach<bool?>(
      _isLocationBasedSearchEnabledStreamUseCase(),
      onData: (enabled) {
        return SettingLoadedState(
          userName: 'John Doe',
          language: 'English',
          locationBasedSearch: enabled ?? true,
        );
      },
      onError: (error, _) => SettingErrorState(error.toString()),
    );
  }

  FutureOr<void> _mapChangeLanguageEventToState(
    ChangeLanguageEvent event,
    Emitter<SettingState> emit,
  ) {
    if (state is SettingLoadedState) {
      final current = state as SettingLoadedState;
      emit(
        SettingLoadedState(
          userName: current.userName,
          language: event.language,
          locationBasedSearch: current.locationBasedSearch,
        ),
      );
    }
  }

  FutureOr<void> _mapToggleLocationBasedSearchEventToState(
    ToggleLocationBasedSearchEvent event,
    Emitter<SettingState> emit,
  ) async {
    await _updateLocationBasedSearchEnabledUseCase(event.enabled);
    if (state is SettingLoadedState) {
      final current = state as SettingLoadedState;
      emit(
        SettingLoadedState(
          userName: current.userName,
          language: current.language,
          locationBasedSearch: event.enabled,
        ),
      );
    }
  }
}
