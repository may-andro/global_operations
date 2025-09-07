import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/ad_panel.dart';
import 'package:global_ops/src/route/route.dart';

class MultiplePanelsFoundWidget extends StatelessWidget {
  const MultiplePanelsFoundWidget({
    super.key,
    required this.adPanelsMap,
    required this.isDetailAvailable,
  });

  final Map<String, List<AdPanelEntity>> adPanelsMap;
  final bool isDetailAvailable;

  static Future<dynamic> _showAsBottomSheet(
    BuildContext context, {
    required Map<String, List<AdPanelEntity>> adPanelsMap,
    required bool isDetailAvailable,
  }) async {
    if (adPanelsMap.isEmpty) return;

    return showModalBottomSheet<dynamic>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DSBottomSheetWidget(
          child: MultiplePanelsFoundWidget(
            adPanelsMap: adPanelsMap,
            isDetailAvailable: isDetailAvailable,
          ),
        );
      },
    );
  }

  static Future<dynamic> _showAsDialog(
    BuildContext context, {
    required Map<String, List<AdPanelEntity>> adPanelsMap,
    required bool isDetailAvailable,
  }) async {
    if (adPanelsMap.isEmpty) return;

    return showDialog<dynamic>(
      context: context,
      builder: (dialogContext) {
        return DSDialogWidget(
          child: MultiplePanelsFoundWidget(
            adPanelsMap: adPanelsMap,
            isDetailAvailable: isDetailAvailable,
          ),
        );
      },
    );
  }

  static Future<dynamic> showAsDialogOrBottomSheet(
    BuildContext context, {
    required Map<String, List<AdPanelEntity>> adPanelsMap,
    required bool isDetailAvailable,
  }) {
    if (context.isDesktop) {
      return _showAsDialog(
        context,
        adPanelsMap: adPanelsMap,
        isDetailAvailable: isDetailAvailable,
      );
    }

    return _showAsBottomSheet(
      context,
      adPanelsMap: adPanelsMap,
      isDetailAvailable: isDetailAvailable,
    );
  }

  List<Widget> getItems(BuildContext context) {
    return adPanelsMap.entries
        .map(
          (entry) => _ItemWidget(
            adPanels: entry.value,
            title: entry.key,
            onTap: isDetailAvailable
                ? () {
                    AdPanelScreen.navigate(context, adPanels: entry.value);
                    context.pop();
                  }
                : null,
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    if (adPanelsMap.isEmpty) return const SizedBox.shrink();
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              context.localizations.adPanelMultiplePanelsFound(
                adPanelsMap.length,
              ),
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            ...getItems(context),
            const DSVerticalSpacerWidget(1),
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({required this.adPanels, required this.title, this.onTap});

  final List<AdPanelEntity> adPanels;
  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DsCardWidget(
      backgroundColor: adPanels.any((adPanel) => adPanel.hasBeenEdited)
          ? context.colorPalette.semantic.info
          : context.colorPalette.invertedBackground.primary,
      radius: context.dimen.radiusLevel1,
      margin: EdgeInsets.only(bottom: context.space()),
      child: ListTile(
        leading: DSCircularIconCardWidget(
          icon: Icons.ad_units_rounded,
          color: context.colorPalette.background.onPrimary,
          backgroundColor: context.colorPalette.background.primary,
        ),
        title: DSTextWidget(
          context.localizations.adPanelPanelTitle(title),
          style: context.typography.bodyMedium,
          color: context.colorPalette.invertedBackground.onPrimary,
        ),
        subtitle: DSTextWidget(
          context.localizations.adPanelPanelSubtitle,
          style: context.typography.labelSmall,
          color: context.colorPalette.invertedBackground.onPrimary,
        ),
        onTap: onTap,
      ),
    );
  }
}
