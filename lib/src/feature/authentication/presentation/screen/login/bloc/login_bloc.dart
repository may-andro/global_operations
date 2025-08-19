import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/login/bloc/login_event.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/login/bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc(this._loginUseCase) : super(const ScreenInitState()) {
    on<LoginSubmittedEvent>(_mapLoginSubmittedEventToState);
    on<ResetPasswordEvent>(_mapResetPasswordEventToState);
  }

  final LoginUseCase _loginUseCase;

  FutureOr<void> _mapLoginSubmittedEventToState(
    LoginSubmittedEvent event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoadingState());

    final params = LoginParams(email: event.email, password: event.password);

    final eitherResult = await _loginUseCase.execute(params);
    eitherResult.fold(
      (failure) =>
          emit(LoginFailureState(message: failure.message ?? 'Login failed')),
      (userId) {
        emit(LoginSuccessState(userId: userId));
      },
    );
  }

  FutureOr<void> _mapResetPasswordEventToState(
    ResetPasswordEvent event,
    Emitter<LoginState> emit,
  ) {}
}
