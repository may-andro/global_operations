import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/paginated_ad_panels_bloc.dart';

extension PaginatedAdPanelsBlocExtension on BuildContext {
  PaginatedAdPanelsBloc get bloc => read<PaginatedAdPanelsBloc>();
}
