import 'package:equatable/equatable.dart';

sealed class TemperedDeviceState extends Equatable {
  const TemperedDeviceState();

  @override
  List<Object?> get props => [];
}

class TemperedDeviceInitialState extends TemperedDeviceState {
  const TemperedDeviceInitialState();
}

class TemperedDeviceProgressState extends TemperedDeviceState {
  const TemperedDeviceProgressState();
}

class DeviceTemperedState extends TemperedDeviceState {
  const DeviceTemperedState();
}

class DeviceUntemperedState extends TemperedDeviceState {
  const DeviceUntemperedState();
}
