import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/ad_panel_screen.dart';
import 'package:global_ops/src/route/route.dart';

class AdPanelDetailWidget extends StatelessWidget {
  const AdPanelDetailWidget({
    super.key,
    required this.adPanels,
    required this.isDetailAvailable,
  });

  final List<AdPanelEntity> adPanels;
  final bool isDetailAvailable;

  static Future<void> _showAsBottomSheet(
    BuildContext context, {
    required List<AdPanelEntity> adPanels,
    required bool isDetailAvailable,
  }) async {
    if (adPanels.isEmpty) return;

    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DSBottomSheetWidget(
          child: AdPanelDetailWidget(
            adPanels: adPanels,
            isDetailAvailable: isDetailAvailable,
          ),
        );
      },
    );
  }

  static Future<void> _showAsDialog(
    BuildContext context, {
    required List<AdPanelEntity> adPanels,
    required bool isDetailAvailable,
  }) async {
    if (adPanels.isEmpty) return;

    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return DSDialogWidget(
          child: AdPanelDetailWidget(
            adPanels: adPanels,
            isDetailAvailable: isDetailAvailable,
          ),
        );
      },
    );
  }

  static Future<void> showAsDialogOrBottomSheet(
    BuildContext context, {
    required List<AdPanelEntity> adPanels,
    required bool isDetailAvailable,
  }) {
    if (context.isDesktop) {
      return _showAsDialog(
        context,
        adPanels: adPanels,
        isDetailAvailable: isDetailAvailable,
      );
    }

    return _showAsBottomSheet(
      context,
      adPanels: adPanels,
      isDetailAvailable: isDetailAvailable,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (adPanels.isEmpty) return const SizedBox.shrink();

    final adPanel = adPanels.first;
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const DSVerticalSpacerWidget(1),
            _InfoItemWidget(
              icon: Icons.ad_units_rounded,
              label: adPanel.objectNumber,
            ),
            if (adPanel.distanceInKm > 0) ...[
              const DSVerticalSpacerWidget(1),
              _InfoItemWidget(
                icon: Icons.route,
                label: context.localizations.adPanelDistanceAway(
                  adPanel.distanceInKm..toStringAsFixed(2),
                ),
              ),
            ],
            const DSVerticalSpacerWidget(1),
            _InfoItemWidget(icon: Icons.my_location, label: adPanel.street),
            const DSVerticalSpacerWidget(1),
            _InfoItemWidget(
              icon: Icons.business_rounded,
              label: adPanel.station,
            ),
            const DSVerticalSpacerWidget(1),
            _InfoItemWidget(
              icon: Icons.location_city_rounded,
              label: adPanel.municipalityPart,
            ),
            const DSVerticalSpacerWidget(2),
            DSHorizontalDividerWidget(
              thickness: 1,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            DSTextWidget(
              context.localizations.adPanelFacesAndCampaigns,
              style: context.typography.titleSmall,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(1),
            ..._getFaceWidgets(context),
            const DSVerticalSpacerWidget(1),
          ],
        ),
      ),
    );
  }

  List<Widget> _getFaceWidgets(BuildContext context) {
    return adPanels
        .map(
          (adPanel) => _ListItemWidget(
            adPanel: adPanel,
            onTap: isDetailAvailable
                ? () {
                    AdPanelScreen.navigate(context, adPanels: adPanels);
                    context.pop();
                  }
                : null,
          ),
        )
        .toList();
  }
}

class _InfoItemWidget extends StatelessWidget {
  const _InfoItemWidget({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DSIconWidget(
          icon,
          size: DSIconSize.medium,
          color: context.colorPalette.background.onPrimary,
        ),
        const DSHorizontalSpacerWidget(1),
        Flexible(
          child: DSTextWidget(
            label,
            color: context.colorPalette.background.onPrimary,
            style: context.typography.bodyMedium,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _ListItemWidget extends StatelessWidget {
  const _ListItemWidget({required this.adPanel, required this.onTap});

  final AdPanelEntity adPanel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DsCardWidget(
      backgroundColor: adPanel.hasBeenEdited
          ? context.colorPalette.brand.secondary
          : context.colorPalette.invertedBackground.primary,
      radius: context.dimen.radiusLevel1,
      margin: EdgeInsets.only(bottom: context.space()),
      child: ListTile(
        leading: DSCircularIconCardWidget(
          icon: Icons.campaign,
          color: context.colorPalette.background.onPrimary,
          backgroundColor: context.colorPalette.background.primary,
        ),
        title: DSTextWidget(
          context.localizations.adPanelFaceLabel(adPanel.faceNumber),
          color: adPanel.hasBeenEdited
              ? context.colorPalette.brand.onSecondary
              : context.colorPalette.invertedBackground.onPrimary,
          style: context.typography.bodyMedium,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        subtitle: DSTextWidget(
          adPanel.campaign,
          color: adPanel.hasBeenEdited
              ? context.colorPalette.brand.onSecondary
              : context.colorPalette.invertedBackground.onPrimary,
          style: context.typography.labelSmall,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        onTap: onTap,
      ),
    );
  }
}
