import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/proximity_ad_panels_bloc.dart';

extension ProximityAdPanelsBlocExtension on BuildContext {
  ProximityAdPanelsBloc get bloc => read<ProximityAdPanelsBloc>();
}
