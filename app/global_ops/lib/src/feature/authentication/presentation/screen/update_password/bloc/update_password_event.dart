import 'package:equatable/equatable.dart';

abstract class UpdatePasswordEvent extends Equatable {
  const UpdatePasswordEvent();

  @override
  List<Object?> get props => [];
}

class LoadUpdatePasswordAccountEvent extends UpdatePasswordEvent {
  const LoadUpdatePasswordAccountEvent();
}

class UpdatePasswordRequestedEvent extends UpdatePasswordEvent {
  const UpdatePasswordRequestedEvent({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });

  final String email;
  final String currentPassword;
  final String newPassword;

  @override
  List<Object?> get props => [email, currentPassword, newPassword];
}
