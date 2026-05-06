import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/locale/domain/domain.dart';
import 'package:global_ops/src/feature/locale/presentation/screen/locale_selection/bloc/locale_selection_event.dart';
import 'package:global_ops/src/feature/locale/presentation/screen/locale_selection/bloc/locale_selection_state.dart';

class LocaleSelectionBloc
    extends Bloc<LocaleSelectionEvent, LocaleSelectionState> {
  LocaleSelectionBloc(this._getLocaleUseCase, this._updateLocaleUseCase)
    : super(LocaleSelectionInitialState()) {
    on<LoadLocaleEvent>(_mapLoadLocaleEventToState);
    on<UpdateLocaleEvent>(_mapUpdateLocaleEventToState);
  }

  final GetLocaleUseCase _getLocaleUseCase;
  final UpdateLocaleUseCase _updateLocaleUseCase;

  Future<void> _mapLoadLocaleEventToState(
    LoadLocaleEvent event,
    Emitter<LocaleSelectionState> emit,
  ) async {
    emit(LocaleSelectionLoadingState());

    final localeEither = await _getLocaleUseCase();
    localeEither.fold(
      (failure) {
        emit(LocaleSelectionLoadErrorState(failure));
      },
      (appLocale) {
        emit(
          LocaleSelectionLoadedState(
            supportedLocales: AppLocalizations.supportedLocales,
            appLocale: appLocale,
          ),
        );
      },
    );
  }

  Future<void> _mapUpdateLocaleEventToState(
    UpdateLocaleEvent event,
    Emitter<LocaleSelectionState> emit,
  ) async {
    final currentState = state;
    if (currentState is! LocaleSelectionLoadedState) return;

    final targetLocale = event.updatedLocale.appLocale;

    // Emit updating state to show progress
    emit(
      LocaleSelectionUpdatingState(
        supportedLocales: currentState.supportedLocales,
        currentLocale: currentState.appLocale,
        targetLocale: targetLocale,
      ),
    );

    final eitherResult = await _updateLocaleUseCase(targetLocale);

    eitherResult.fold(
      (failure) {
        emit(
          LocaleSelectionUpdateErrorState(
            supportedLocales: currentState.supportedLocales,
            appLocale: currentState.appLocale,
            failure: failure,
          ),
        );
      },
      (_) {
        // Success - emit success state
        emit(
          LocaleSelectionUpdateSuccessState(
            supportedLocales: currentState.supportedLocales,
            appLocale: targetLocale,
          ),
        );
      },
    );
  }
}
