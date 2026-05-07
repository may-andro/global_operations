import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fb_add_scrapper/src/feature/feature_toggle/presentation/screen/bloc/feature_toggle_bloc.dart';

extension FeatureFlagBlocExtension on BuildContext {
  FeatureToggleBloc get bloc => read<FeatureToggleBloc>();
}
