import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/security/presentation/widget/date_time/bloc/date_time_validation_bloc.dart';

extension DateTimeValidationBlocExtension on BuildContext {
  DateTimeValidationBloc get bloc => read<DateTimeValidationBloc>();
}
