import 'package:equatable/equatable.dart';

sealed class TemperedDeviceEvent extends Equatable {
  const TemperedDeviceEvent();

  @override
  List<Object?> get props => [];
}

class RequestTemperedDeviceEvent extends TemperedDeviceEvent {
  const RequestTemperedDeviceEvent();
}
