import 'package:equatable/equatable.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class ScreenInitState extends LoginState {
  const ScreenInitState();
}

class LoginLoadingState extends LoginState {
  const LoginLoadingState();
}

class LoginSuccessState extends LoginState {
  const LoginSuccessState({required this.userId});

  final String userId;

  @override
  List<Object?> get props => [userId];
}

class LoginFailureState extends LoginState {
  const LoginFailureState({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
