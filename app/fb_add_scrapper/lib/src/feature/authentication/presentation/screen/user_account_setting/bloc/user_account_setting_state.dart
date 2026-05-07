import 'package:equatable/equatable.dart';

abstract class UserAccountSettingState extends Equatable {
  const UserAccountSettingState();

  @override
  List<Object?> get props => [];
}

class UserAccountSettingInitialState extends UserAccountSettingState {}

class UserAccountLoadingState extends UserAccountSettingState {}

class UserAccountLoadedState extends UserAccountSettingState {
  const UserAccountLoadedState(this.userName);

  final String userName;

  @override
  List<Object?> get props => [userName];
}

class UserAccountErrorState extends UserAccountSettingState {
  const UserAccountErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
