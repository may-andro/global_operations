import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fb_add_scrapper/src/feature/security/presentation/widget/tempered_device/bloc/tempered_device_bloc.dart';

extension TemperedDeviceBlocExtension on BuildContext {
  TemperedDeviceBloc get bloc => read<TemperedDeviceBloc>();
}
