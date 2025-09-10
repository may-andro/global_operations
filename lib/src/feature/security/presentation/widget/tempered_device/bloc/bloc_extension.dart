import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/security/presentation/widget/tempered_device/bloc/tempered_device_bloc.dart';

extension TemperedDeviceBlocExtension on BuildContext {
  TemperedDeviceBloc get bloc => read<TemperedDeviceBloc>();
}
