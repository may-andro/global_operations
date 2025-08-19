import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/bloc/ad_panels_event.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/bloc/ad_panels_state.dart';
import 'package:global_ops/src/feature/location/location.dart';

class AdPanelsBloc extends Bloc<AdPanelsEvent, AdPanelsState> {
  AdPanelsBloc(this._isLocationBasedSearchEnabledStreamUseCase)
    : super(AdPanelsInitialState()) {
    on<LoadAdPanelsEvent>(_mapLoadAdPanelsEventToState);
  }

  final IsLocationBasedSearchEnabledStreamUseCase
  _isLocationBasedSearchEnabledStreamUseCase;

  Future<void> _mapLoadAdPanelsEventToState(
    LoadAdPanelsEvent event,
    Emitter<AdPanelsState> emit,
  ) async {
    emit(AdPanelsLoadingState());
    await emit.forEach<bool?>(
      _isLocationBasedSearchEnabledStreamUseCase(),
      onData: (enabled) {
        if (enabled == null) {
          // Remain in loading state if the initial value is null
          return state;
        }
        return AdPanelsLoadedState(enabled);
      },
      onError: (error, _) => AdPanelsErrorState(error.toString()),
    );
  }
}
