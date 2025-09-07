import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/widget/widget.dart';

class ErrorContentWidget extends StatelessWidget {
  const ErrorContentWidget({
    required this.message,
    required this.onRefresh,
    super.key,
  });

  final String message;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    return InfoCardWidget(
      icon: Icons.error_outline,
      iconColor: context.colorPalette.semantic.error,
      title: context.localizations.adPanelErrorTitle,
      description: message,
      action: context.localizations.adPanelRefresh,
      actionIcon: Icons.refresh,
      onPressed: onRefresh,
    );
  }
}
