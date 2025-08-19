import 'package:equatable/equatable.dart';

abstract class SettingState extends Equatable {
  const SettingState();

  @override
  List<Object?> get props => [];
}

class SettingInitialState extends SettingState {}

class SettingLoadedState extends SettingState {
  const SettingLoadedState({
    required this.userName,
    required this.language,
    required this.locationBasedSearch,
  });

  final String userName;
  final String language;
  final bool locationBasedSearch;

  @override
  List<Object?> get props => [userName, language, locationBasedSearch];
}

class SettingErrorState extends SettingState {
  const SettingErrorState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SettingLoggedOutState extends SettingState {}

class SettingAccountDeletedState extends SettingState {}
