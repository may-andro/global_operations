import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/feature_toggle_bloc.dart';

extension FeatureFlagBlocExtension on BuildContext {
  FeatureToggleBloc get bloc => read<FeatureToggleBloc>();
}
