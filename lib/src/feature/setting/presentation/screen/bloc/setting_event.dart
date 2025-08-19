import 'package:equatable/equatable.dart';

abstract class SettingEvent extends Equatable {
  const SettingEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettingsEvent extends SettingEvent {}

class ChangeLanguageEvent extends SettingEvent {
  const ChangeLanguageEvent(this.language);

  final String language;

  @override
  List<Object?> get props => [language];
}

class ToggleLocationBasedSearchEvent extends SettingEvent {
  const ToggleLocationBasedSearchEvent(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
