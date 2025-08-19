import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/widget/widget.dart';

class EmptyContentWidget extends StatelessWidget {
  const EmptyContentWidget({required this.onRefresh, super.key});

  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return InfoCardWidget(
      icon: Icons.inbox_outlined,
      iconColor: context.colorPalette.neutral.grey1,
      title: context.localizations.adPanelEmptyTitle,
      description: context.localizations.adPanelEmptyDescription,
      action: context.localizations.adPanelRefresh,
      actionIcon: Icons.refresh,
      onPressed: onRefresh,
    );
  }
}
