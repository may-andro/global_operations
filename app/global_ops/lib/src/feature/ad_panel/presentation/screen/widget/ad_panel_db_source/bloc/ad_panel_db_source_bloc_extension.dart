import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/widget/ad_panel_db_source/bloc/ad_panel_db_source_bloc.dart';

extension AdPanelDbSourceBlocExtension on BuildContext {
  AdPanelDbSourceBloc get bloc => read<AdPanelDbSourceBloc>();
}
