import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/reset_password/bloc/reset_password_event.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/reset_password/bloc/reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc(this._resetPasswordRequestUseCase)
    : super(ResetPasswordInitialState()) {
    on<ResetPasswordRequestedEvent>(_mapResetPasswordRequestedEventToState);
  }

  final ResetPasswordRequestUseCase _resetPasswordRequestUseCase;

  FutureOr<void> _mapResetPasswordRequestedEventToState(
    ResetPasswordRequestedEvent event,
    Emitter<ResetPasswordState> emit,
  ) async {
    emit(ResetPasswordLoadingState());
    final eitherResult = await _resetPasswordRequestUseCase(event.email);

    eitherResult.fold(
      (failure) {
        emit(
          ResetPasswordErrorState(message: failure.message ?? 'Unknown error'),
        );
      },
      (success) {
        emit(ResetPasswordSuccessState());
      },
    );
  }
}
