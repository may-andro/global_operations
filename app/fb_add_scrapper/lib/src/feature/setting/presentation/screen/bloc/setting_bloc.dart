import 'dart:async';

import 'package:fb_add_scrapper/src/feature/feature_toggle/feature_toggle.dart';
import 'package:fb_add_scrapper/src/feature/setting/presentation/screen/bloc/setting_event.dart';
import 'package:fb_add_scrapper/src/feature/setting/presentation/screen/bloc/setting_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SettingBloc(this._isFeatureEnabledUseCase)
    : super(const SettingInitialState()) {
    on<LoadSettingsEvent>(_mapLoadSettingsEventToState);
  }

  final IsFeatureEnabledUseCase _isFeatureEnabledUseCase;

  Future<void> _mapLoadSettingsEventToState(
    LoadSettingsEvent event,
    Emitter<SettingState> emit,
  ) async {
    emit(const SettingLoadedState());
  }
}
