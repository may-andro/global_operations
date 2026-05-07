import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fb_add_scrapper/src/feature/authentication/domain/domain.dart';
import 'package:fb_add_scrapper/src/feature/authentication/presentation/screen/logout/bloc/logout_event.dart';
import 'package:fb_add_scrapper/src/feature/authentication/presentation/screen/logout/bloc/logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  LogoutBloc(this._logoutUseCase) : super(LogoutInitialState()) {
    on<LogoutRequestedEvent>(_mapLogoutRequestedEventToState);
  }

  final LogoutUseCase _logoutUseCase;

  FutureOr<void> _mapLogoutRequestedEventToState(
    LogoutRequestedEvent event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutInProgressState());

    final eitherResult = await _logoutUseCase();
    eitherResult.fold(
      (failure) =>
          emit(LogoutFailureState(error: failure.message ?? 'Logout failed')),
      (_) => emit(LogoutSuccessState()),
    );
  }
}
