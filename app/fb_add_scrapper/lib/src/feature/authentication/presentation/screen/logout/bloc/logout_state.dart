import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();

  @override
  List<Object?> get props => [];
}

class LogoutInitialState extends LogoutState {}

class LogoutInProgressState extends LogoutState {}

class LogoutSuccessState extends LogoutState {}

class LogoutFailureState extends LogoutState {
  const LogoutFailureState({required this.error});

  final String error;

  @override
  List<Object?> get props => [error];
}
