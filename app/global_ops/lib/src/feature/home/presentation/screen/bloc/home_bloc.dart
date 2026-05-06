import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/home/presentation/screen/bloc/home_event.dart';
import 'package:global_ops/src/feature/home/presentation/screen/bloc/home_state.dart';
import 'package:meta/meta.dart';

const int maxLogoClickThreshold = 6;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this.buildConfig)
    : super(
        HomeState(
          isDeveloperModeEnabled: buildConfig.buildEnvironment.isDevMenuEnabled,
        ),
      ) {
    on<TabChangedEvent>(_mapTabChangedEventToState);
    on<LogoTappedEvent>(_mapLogoTappedEventToState);
  }

  @protected
  final BuildConfig buildConfig;

  int _lastHeaderLogoTapTimeStamp = 0;

  FutureOr<void> _mapLogoTappedEventToState(
    LogoTappedEvent event,
    Emitter<HomeState> emit,
  ) {
    int logoClickCount = state.logoClickCount;
    final currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    if (currentTimeStamp - _lastHeaderLogoTapTimeStamp < 1000) {
      logoClickCount += 1;
    } else {
      logoClickCount = 1;
    }
    _lastHeaderLogoTapTimeStamp = currentTimeStamp;

    if (logoClickCount >= maxLogoClickThreshold) {
      emit(state.copyWith(isDeveloperModeEnabled: true, logoClickCount: 0));
    } else {
      emit(state.copyWith(logoClickCount: logoClickCount));
    }
  }

  FutureOr<void> _mapTabChangedEventToState(
    TabChangedEvent event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(selectedIndex: event.index));
  }
}
