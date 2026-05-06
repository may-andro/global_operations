import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/security/domain/domain.dart';
import 'package:global_ops/src/feature/security/presentation/widget/tempered_device/bloc/tempered_device_event.dart';
import 'package:global_ops/src/feature/security/presentation/widget/tempered_device/bloc/tempered_device_state.dart';

class TemperedDeviceBloc
    extends Bloc<TemperedDeviceEvent, TemperedDeviceState> {
  TemperedDeviceBloc(this._temperedDeviceValidationUseCase)
    : super(const TemperedDeviceInitialState()) {
    on<RequestTemperedDeviceEvent>(_mapRequestTemperedDeviceEventToState);
  }

  final TemperedDeviceValidationUseCase _temperedDeviceValidationUseCase;

  Future<void> _mapRequestTemperedDeviceEventToState(
    RequestTemperedDeviceEvent event,
    Emitter<TemperedDeviceState> emit,
  ) async {
    emit(const TemperedDeviceProgressState());

    final result = await _temperedDeviceValidationUseCase();
    result.fold(
      (failure) => emit(const DeviceUntemperedState()),
      (isTempered) => emit(
        isTempered
            ? const DeviceTemperedState()
            : const DeviceUntemperedState(),
      ),
    );
  }
}
