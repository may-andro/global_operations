import 'dart:async';

import 'package:core/core.dart';
import 'package:global_ops/src/feature/locale/domain/repository/locale_repository.dart';
import 'package:use_case/use_case.dart';

sealed class GetLocaleFailure extends BasicFailure {
  const GetLocaleFailure({super.message, super.cause});
}

class GetLocaleStorageFailure extends GetLocaleFailure {
  const GetLocaleStorageFailure({super.message, super.cause});
}

class GetLocaleValidationFailure extends GetLocaleFailure {
  const GetLocaleValidationFailure({super.message, super.cause});
}

class GetLocaleNotFoundFailure extends GetLocaleFailure {
  const GetLocaleNotFoundFailure({super.message, super.cause});
}

class GetLocaleUnknownFailure extends GetLocaleFailure {
  const GetLocaleUnknownFailure({super.message, super.cause});
}

class GetLocaleUseCase extends BaseNoParamUseCase<AppLocale, GetLocaleFailure> {
  GetLocaleUseCase(this._localeRepository);

  final LocaleRepository _localeRepository;

  @override
  FutureOr<Either<GetLocaleFailure, AppLocale>> execute() async {
    final appLocale = await _localeRepository.appLocale;
    return Right(appLocale);
  }

  @override
  GetLocaleFailure mapErrorToFailure(Object e, StackTrace st) {
    final errorMessage = e.toString().toLowerCase();

    // Storage-related errors (preferences, cache, database, disk issues)
    if (errorMessage.contains('storage') ||
        errorMessage.contains('preferences') ||
        errorMessage.contains('cache') ||
        errorMessage.contains('database') ||
        errorMessage.contains('file') ||
        errorMessage.contains('disk') ||
        errorMessage.contains('space') ||
        errorMessage.contains('corrupt')) {
      return GetLocaleStorageFailure(
        message: 'Storage error while retrieving locale settings',
        cause: e,
      );
    }

    // Validation-related errors (invalid locale format, parsing issues)
    if (errorMessage.contains('validation') ||
        errorMessage.contains('invalid') ||
        errorMessage.contains('format') ||
        errorMessage.contains('parse') ||
        errorMessage.contains('decode') ||
        errorMessage.contains('json') ||
        errorMessage.contains('serialization')) {
      return GetLocaleValidationFailure(
        message: 'Invalid locale data format',
        cause: e,
      );
    }

    // Not found errors (locale setting doesn't exist)
    if (errorMessage.contains('not found') ||
        errorMessage.contains('missing') ||
        errorMessage.contains('null') ||
        errorMessage.contains('empty') ||
        errorMessage.contains('no such') ||
        errorMessage.contains('key not found')) {
      return GetLocaleNotFoundFailure(
        message: 'Locale settings not found',
        cause: e,
      );
    }

    // Default to unknown failure
    return GetLocaleUnknownFailure(
      message: 'An unexpected error occurred while retrieving locale settings',
      cause: e,
    );
  }
}
