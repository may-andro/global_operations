import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/widget/widget.dart';

class EmptyContentWidget extends StatelessWidget {
  const EmptyContentWidget({required this.searchQuery, super.key});

  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    return InfoCardWidget(
      icon: Icons.warning_amber_rounded,
      iconColor: context.colorPalette.neutral.grey1,
      title: searchQuery.isEmpty ? 'No feature flag' : 'No results found',
      description: searchQuery.isEmpty
          ? "Couldn't find any feature flags. Please try refreshing."
          : 'No feature flag match your search criteria.',
      action: searchQuery.isEmpty ? 'Refresh' : 'Clear search',
      actionIcon: searchQuery.isEmpty
          ? Icons.refresh_rounded
          : Icons.clear_all_rounded,
      onPressed: () {
        if (searchQuery.isNotEmpty) {
          context.bloc.add(const UpdateSearchQueryEvent(''));
          return;
        }
        context.bloc.add(const ResetFFEvent());
      },
    );
  }
}
