import 'dart:async';

import 'package:design_system/design_system.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/splash/presentation/bloc/splash_event.dart';
import 'package:global_ops/src/feature/splash/presentation/bloc/splash_state.dart';
import 'package:module_injector/module_injector.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc(this._moduleInjectorController, this._moduleConfigurators)
    : super(SetUpProgressState.initial()) {
    on<InitEvent>(_onInitEventToState);
  }

  final ModuleInjectorController _moduleInjectorController;

  final List<ModuleConfigurator> _moduleConfigurators;

  final _receivedSetUpStatus = <InjectionStatus>[];

  bool errorDuringDI = false;

  FutureOr<void> _onInitEventToState(
    InitEvent event,
    Emitter<SplashState> emit,
  ) async {
    await emit.onEach<InjectionStatus>(
      _moduleInjectorController.setUpDIGraph(
        configurators: _moduleConfigurators,
      ),
      onData: (setUpStatus) {
        _receivedSetUpStatus.add(setUpStatus);
        final progress =
            _receivedSetUpStatus.length / InjectionStatus.values.length;
        emit(SetUpProgressState(_receivedSetUpStatus, progress));
      },
      onError: (error, stackTrace) {
        errorDuringDI = true;
        if (error is InjectionException) {
          emit(SetUpErrorState(error.message ?? error.cause ?? error));
          return;
        }
        emit(SetUpErrorState(error));
      },
    );

    if (!errorDuringDI) {
      emit(const SetUpCompetedState(DesignSystem.primary));
    }
  }
}
