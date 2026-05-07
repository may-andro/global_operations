import 'package:equatable/equatable.dart';

abstract class UserAccountSettingEvent extends Equatable {
  const UserAccountSettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadUserAccountEvent extends UserAccountSettingEvent {}
