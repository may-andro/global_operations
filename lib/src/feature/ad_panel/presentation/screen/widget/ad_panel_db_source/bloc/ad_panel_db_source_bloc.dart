import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/widget/ad_panel_db_source/bloc/ad_panel_db_source_event.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/widget/ad_panel_db_source/bloc/ad_panel_db_source_state.dart';
import 'package:global_ops/src/feature/feature_toggle/feature_toggle.dart';

class AdPanelDbSourceBloc
    extends Bloc<AdPanelDbSourceEvent, AdPanelDbSourceState> {
  AdPanelDbSourceBloc(
    this._getAdPanelsDbSourcePathsUseCase,
    this._getAdPanelsDbSourcePathStreamUseCase,
    this._updateAdPanelsDbSourcePathUseCase,
    this._isFeatureEnabledUseCase,
  ) : super(const AdPanelDbSourceLoadingState()) {
    on<LoadDbSourcesEvent>(_mapLoadDbSourcesEventToState);
    on<SelectDbSourceEvent>(_mapSelectDbSourceEventToState);
  }

  final GetAdPanelsDbSourcePathsUseCase _getAdPanelsDbSourcePathsUseCase;
  final GetAdPanelsDbSourcePathStreamUseCase
  _getAdPanelsDbSourcePathStreamUseCase;
  final UpdateAdPanelsDbSourcePathUseCase _updateAdPanelsDbSourcePathUseCase;
  final IsFeatureEnabledUseCase _isFeatureEnabledUseCase;

  Future<void> _mapLoadDbSourcesEventToState(
    LoadDbSourcesEvent event,
    Emitter<AdPanelDbSourceState> emit,
  ) async {
    emit(const AdPanelDbSourceLoadingState());
    final isEnabledEither = await _isFeatureEnabledUseCase(
      Feature.forceDemoData,
    );
    final isEnabled = isEnabledEither.fold((_) => true, (right) => !right);
    final result = await _getAdPanelsDbSourcePathsUseCase();
    await emit.forEach<String>(
      _getAdPanelsDbSourcePathStreamUseCase(),
      onData: (selectedSource) {
        return result.fold(
          (failure) =>
              const AdPanelDbSourceErrorState('Failed to load sources'),
          (sources) {
            if (sources.isEmpty) {
              return const AdPanelDbSourceErrorState('No sources found');
            }
            final validSelected = sources.contains(selectedSource)
                ? selectedSource
                : sources.first;
            return AdPanelDbSourceLoadedState(
              sources: sources,
              selectedSource: validSelected,
              isEnabled: isEnabled,
            );
          },
        );
      },
      onError: (error, stackTrace) =>
          AdPanelDbSourceErrorState(error.toString()),
    );
  }

  void _mapSelectDbSourceEventToState(
    SelectDbSourceEvent event,
    Emitter<AdPanelDbSourceState> emit,
  ) {
    final currentState = state;
    if (currentState is AdPanelDbSourceLoadedState) {
      _updateAdPanelsDbSourcePathUseCase(event.source);
      emit(currentState.copyWith(selectedSource: event.source));
    }
  }
}
