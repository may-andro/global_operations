import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';

class ViewTypeToggleButtonWidget extends StatelessWidget {
  const ViewTypeToggleButtonWidget({
    required this.viewType,
    required this.onToggle,
    required this.isVisible,
    super.key,
  });

  final AdPanelViewType viewType;
  final void Function(AdPanelViewType) onToggle;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 300.ms,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: isVisible
          ? FloatingActionButton.extended(
              onPressed: () {
                final newViewType = viewType == AdPanelViewType.map
                    ? AdPanelViewType.list
                    : AdPanelViewType.map;
                onToggle(newViewType);
              },
              tooltip: viewType == AdPanelViewType.map
                  ? context.localizations.adPanelShowListViewTooltip
                  : context.localizations.adPanelShowMapViewTooltip,
              icon: Icon(viewType.icon),
              label: Text(
                viewType == AdPanelViewType.map
                    ? context.localizations.adPanelShowListViewTooltip
                    : context.localizations.adPanelShowMapViewTooltip,
              ),
            )
          : const SizedBox.shrink(key: ValueKey('not_loading')),
    );
  }
}
