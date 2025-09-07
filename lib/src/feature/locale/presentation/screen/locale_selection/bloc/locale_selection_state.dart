import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/locale/domain/domain.dart';

sealed class LocaleSelectionState extends Equatable {
  const LocaleSelectionState();

  @override
  List<Object?> get props => [];
}

class LocaleSelectionInitialState extends LocaleSelectionState {}

class LocaleSelectionLoadingState extends LocaleSelectionState {}

class LocaleSelectionLoadedState extends LocaleSelectionState {
  const LocaleSelectionLoadedState({
    required this.supportedLocales,
    required this.appLocale,
  });

  final List<Locale> supportedLocales;
  final AppLocale appLocale;

  LocaleSelectionLoadedState copyWith({
    List<Locale>? supportedLocales,
    AppLocale? appLocale,
  }) {
    return LocaleSelectionLoadedState(
      supportedLocales: supportedLocales ?? this.supportedLocales,
      appLocale: appLocale ?? this.appLocale,
    );
  }

  @override
  List<Object?> get props => [supportedLocales, appLocale];
}

class LocaleSelectionUpdatingState extends LocaleSelectionState {
  const LocaleSelectionUpdatingState({
    required this.supportedLocales,
    required this.currentLocale,
    required this.targetLocale,
  });

  final List<Locale> supportedLocales;
  final AppLocale currentLocale;
  final AppLocale targetLocale;

  @override
  List<Object?> get props => [supportedLocales, currentLocale, targetLocale];
}

class LocaleSelectionUpdateSuccessState extends LocaleSelectionState {
  const LocaleSelectionUpdateSuccessState({
    required this.supportedLocales,
    required this.appLocale,
  });

  final List<Locale> supportedLocales;
  final AppLocale appLocale;

  @override
  List<Object?> get props => [supportedLocales, appLocale];
}

class LocaleSelectionLoadErrorState extends LocaleSelectionState {
  const LocaleSelectionLoadErrorState(this.failure);

  final GetLocaleFailure failure;

  @override
  List<Object?> get props => [failure];
}

class LocaleSelectionUpdateErrorState extends LocaleSelectionState {
  const LocaleSelectionUpdateErrorState({
    required this.supportedLocales,
    required this.appLocale,
    required this.failure,
  });

  final List<Locale> supportedLocales;
  final AppLocale appLocale;
  final UpdateLocaleFailure failure;

  @override
  List<Object?> get props => [supportedLocales, appLocale, failure];
}
