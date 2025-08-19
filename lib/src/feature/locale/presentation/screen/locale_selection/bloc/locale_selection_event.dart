import 'dart:ui';

import 'package:equatable/equatable.dart';

// Events
abstract class LocaleSelectionEvent extends Equatable {
  const LocaleSelectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocaleEvent extends LocaleSelectionEvent {
  const LoadLocaleEvent();
}

class UpdateLocaleEvent extends LocaleSelectionEvent {
  const UpdateLocaleEvent(this.updatedLocale);

  final Locale updatedLocale;

  @override
  List<Object?> get props => [updatedLocale];
}
