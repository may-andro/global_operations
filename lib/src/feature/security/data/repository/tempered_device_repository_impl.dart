import 'package:flutter/foundation.dart';
import 'package:global_ops/src/feature/security/domain/domain.dart';
import 'package:safe_device/safe_device.dart';

class TemperedDeviceRepositoryImpl implements TemperedDeviceRepository {
  @override
  Future<bool> isSafeDevice() {
    if (kIsWeb) {
      return Future.value(true);
    }

    return SafeDevice.isSafeDevice;
  }
}
