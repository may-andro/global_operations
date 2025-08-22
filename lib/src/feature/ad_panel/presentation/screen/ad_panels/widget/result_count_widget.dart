import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

class ResultCountWidget extends StatelessWidget {
  const ResultCountWidget({super.key, required this.count, this.radiusInKm});

  final int count;
  final int? radiusInKm;

  @override
  Widget build(BuildContext context) {
    return DSTextWidget(
      radiusInKm == null
          ? context.localizations.adPanelSearchResultCount(count)
          : context.localizations.adPanelSearchResultCountWithRadius(
              count,
              radiusInKm?.toStringAsFixed(2) ?? '0.00',
            ),
      style: context.typography.labelSmall,
      color: context.colorPalette.background.onPrimary,
    );
  }
}
