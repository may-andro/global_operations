import 'dart:async';

import 'package:core/core.dart';
import 'package:global_ops/src/feature/locale/domain/repository/locale_repository.dart';
import 'package:use_case/use_case.dart';

sealed class UpdateLocaleFailure extends BasicFailure {
  const UpdateLocaleFailure({super.message, super.cause});
}

class UpdateLocaleCacheFailure extends UpdateLocaleFailure {
  const UpdateLocaleCacheFailure({super.message, super.cause});
}

class UpdateLocaleServiceLocatorFailure extends UpdateLocaleFailure {
  const UpdateLocaleServiceLocatorFailure({super.message, super.cause});
}

class UpdateLocaleValidationFailure extends UpdateLocaleFailure {
  const UpdateLocaleValidationFailure({super.message, super.cause});
}

class UpdateLocaleIntlFailure extends UpdateLocaleFailure {
  const UpdateLocaleIntlFailure({super.message, super.cause});
}

class UpdateLocaleStreamFailure extends UpdateLocaleFailure {
  const UpdateLocaleStreamFailure({super.message, super.cause});
}

class UpdateLocaleUnknownFailure extends UpdateLocaleFailure {
  const UpdateLocaleUnknownFailure({super.message, super.cause});
}

class UpdateLocaleUseCase
    extends BaseUseCase<void, AppLocale, UpdateLocaleFailure> {
  UpdateLocaleUseCase(this._localeRepository);

  final LocaleRepository _localeRepository;

  @override
  FutureOr<Either<UpdateLocaleFailure, void>> execute(AppLocale input) async {
    // Validate input locale
    if (!_isValidLocale(input)) {
      return const Left(
        UpdateLocaleValidationFailure(
          message: 'Invalid locale provided for update',
        ),
      );
    }

    await _localeRepository.updateAppLocale(input);
    return const Right(null);
  }

  bool _isValidLocale(AppLocale locale) {
    // Basic validation - ensure language code is not empty and follows format
    final languageCode = locale.languageCode;
    if (languageCode.isEmpty ||
        languageCode.length < 2 ||
        languageCode.length > 3) {
      return false;
    }

    // Check if it contains only alphabetic characters
    return RegExp(r'^[a-z]{2,3}$').hasMatch(languageCode.toLowerCase());
  }

  @override
  UpdateLocaleFailure mapErrorToFailure(Object e, StackTrace st) {
    final errorMessage = e.toString().toLowerCase();

    // Cache-related errors (AppLocaleCache.put() failures)
    if (errorMessage.contains('cache') ||
        errorMessage.contains('preferences') ||
        errorMessage.contains('storage') ||
        errorMessage.contains('database') ||
        errorMessage.contains('disk') ||
        errorMessage.contains('space')) {
      return UpdateLocaleCacheFailure(
        message: 'Failed to cache locale settings',
        cause: e,
      );
    }

    // Service locator errors (unregister/register failures)
    if (errorMessage.contains('service locator') ||
        errorMessage.contains('locator') ||
        errorMessage.contains('register') ||
        errorMessage.contains('unregister') ||
        errorMessage.contains('dependency') ||
        errorMessage.contains('injection')) {
      return UpdateLocaleServiceLocatorFailure(
        message: 'Failed to update service locator with new locale',
        cause: e,
      );
    }

    // Intl.defaultLocale setting errors
    if (errorMessage.contains('intl') ||
        errorMessage.contains('default locale') ||
        errorMessage.contains('locale setting') ||
        errorMessage.contains('internationalization')) {
      return UpdateLocaleIntlFailure(
        message: 'Failed to set default locale for internationalization',
        cause: e,
      );
    }

    // Stream controller errors
    if (errorMessage.contains('stream') ||
        errorMessage.contains('controller') ||
        errorMessage.contains('broadcast') ||
        errorMessage.contains('closed') ||
        errorMessage.contains('listener')) {
      return UpdateLocaleStreamFailure(
        message: 'Failed to notify locale change via stream',
        cause: e,
      );
    }

    // Validation-related errors
    if (errorMessage.contains('validation') ||
        errorMessage.contains('invalid') ||
        errorMessage.contains('format') ||
        errorMessage.contains('language code') ||
        errorMessage.contains('locale code')) {
      return UpdateLocaleValidationFailure(
        message: 'Invalid locale format or language code',
        cause: e,
      );
    }

    // Default to unknown failure
    return UpdateLocaleUnknownFailure(
      message: 'An unexpected error occurred while updating locale',
      cause: e,
    );
  }
}
