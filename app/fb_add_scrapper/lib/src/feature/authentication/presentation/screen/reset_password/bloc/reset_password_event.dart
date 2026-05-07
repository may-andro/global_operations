import 'package:equatable/equatable.dart';

abstract class ResetPasswordEvent extends Equatable {
  const ResetPasswordEvent();

  @override
  List<Object?> get props => [];
}

class ResetPasswordRequestedEvent extends ResetPasswordEvent {
  const ResetPasswordRequestedEvent(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}
