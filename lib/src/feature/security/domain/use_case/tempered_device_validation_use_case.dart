import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:global_ops/src/feature/feature_toggle/feature_toggle.dart';
import 'package:global_ops/src/feature/security/domain/repository/tempered_device_repository.dart';
import 'package:meta/meta.dart' as meta;
import 'package:use_case/use_case.dart';

class TemperedDeviceValidationFailure extends BasicFailure {
  const TemperedDeviceValidationFailure({super.message, super.cause});
}

class TemperedDeviceValidationUseCase
    extends BaseNoParamUseCase<bool, TemperedDeviceValidationFailure> {
  TemperedDeviceValidationUseCase(
    this._temperedDeviceRepository,
    this._isFeatureEnabledUseCase,
  );

  final TemperedDeviceRepository _temperedDeviceRepository;
  final IsFeatureEnabledUseCase _isFeatureEnabledUseCase;

  @meta.protected
  @override
  FutureOr<Either<TemperedDeviceValidationFailure, bool>> execute() async {
    final isEnabledEither = await _isFeatureEnabledUseCase(
      Feature.temperedDeviceSafety,
    );
    final isFeatureEnabled = isEnabledEither.fold(
      (_) => true,
      (isEnabled) => isEnabled,
    );

    if (!isFeatureEnabled) {
      return const Right(false);
    }

    final isSafeDevice = await _temperedDeviceRepository.isSafeDevice();
    return Right(!isSafeDevice);
  }

  @override
  TemperedDeviceValidationFailure mapErrorToFailure(Object e, StackTrace st) {
    return TemperedDeviceValidationFailure(message: e.toString(), cause: e);
  }
}
