import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/locale/domain/domain.dart';

extension GetLocaleFailureExtension on GetLocaleFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      GetLocaleStorageFailure() =>
        context.localizations.errorLocaleStorageFailure,
      GetLocaleValidationFailure() =>
        context.localizations.errorLocaleValidationFailure,
      GetLocaleNotFoundFailure() => context.localizations.errorLocaleNotFound,
      GetLocaleUnknownFailure() => context.localizations.errorLocaleLoadUnknown,
    };
  }
}

extension UpdateLocaleFailureExtension on UpdateLocaleFailure {
  String getMessage(BuildContext context) {
    return switch (this) {
      UpdateLocaleCacheFailure() =>
        context.localizations.errorLocaleCacheFailure,
      UpdateLocaleServiceLocatorFailure() =>
        context.localizations.errorLocaleServiceLocatorFailure,
      UpdateLocaleIntlFailure() => context.localizations.errorLocaleIntlFailure,
      UpdateLocaleStreamFailure() =>
        context.localizations.errorLocaleStreamFailure,
      UpdateLocaleValidationFailure() =>
        context.localizations.errorLocaleUpdateValidationFailure,
      UpdateLocaleUnknownFailure() =>
        context.localizations.errorLocaleUpdateUnknown,
    };
  }
}
