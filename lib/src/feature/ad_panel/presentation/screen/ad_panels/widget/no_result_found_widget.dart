import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/widget/widget.dart';

class NoResultFoundWidget extends StatelessWidget {
  const NoResultFoundWidget({required this.onRefresh, super.key});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return InfoCardWidget(
      icon: Icons.search_off,
      iconColor: context.colorPalette.neutral.grey1,
      title: context.localizations.adPanelNoResultTitle,
      description: context.localizations.adPanelNoResultDescription,
      action: context.localizations.adPanelNoResultClearFilters,
      actionIcon: Icons.clear_all,
      onPressed: onRefresh,
    );
  }
}
