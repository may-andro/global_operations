import 'package:equatable/equatable.dart';

abstract class DeleteAccountEvent extends Equatable {
  const DeleteAccountEvent();

  @override
  List<Object?> get props => [];
}

class LoadDeleteAccountEvent extends DeleteAccountEvent {
  const LoadDeleteAccountEvent();
}

class DeleteAccountSubmittedEvent extends DeleteAccountEvent {
  const DeleteAccountSubmittedEvent({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}
