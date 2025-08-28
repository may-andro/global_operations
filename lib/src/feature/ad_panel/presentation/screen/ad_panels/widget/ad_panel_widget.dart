import 'dart:math';

import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/route/route.dart';
import 'package:go_router/go_router.dart';

class AdPanelWidget extends StatelessWidget {
  const AdPanelWidget({required this.adPanels, super.key});

  final List<AdPanelEntity> adPanels;

  /// Calculates the height of this widget based on its content and padding
  static double getHeight(BuildContext context) {
    // Get spacing and typography values from design system
    final spacing = context.space();
    final paddingFactor = context.isMobile ? 2 : 1;
    final cardPadding = spacing * paddingFactor;

    // Calculate text heights based on typography
    final titleHeight = context.getTextHeight(
      context.typography.titleMedium,
      1,
    );
    final bodyHeight = context.getTextHeight(context.typography.bodyMedium, 1);

    // Calculate icon heights
    final smallIconHeight =
        spacing * (context.isDesktop ? 1.5 : 2); // DSIconSize.small

    // Widget structure breakdown:
    // 1. Card padding (top + bottom)
    final totalCardPadding = cardPadding * 2;

    // 2. Title row (object number + arrow icon)
    // Take the maximum between text height and icon height
    final titleRowHeight = max(titleHeight, smallIconHeight);

    // 3. Spacing after title
    final spacingAfterTitle = spacing * 0.5;

    // 4. Three _ItemWidget rows (location, municipality, face count)
    // Each row has both icon and text, so take the maximum height
    final itemRowHeight = max(bodyHeight, smallIconHeight);
    final totalItemsHeight = itemRowHeight * 3;

    // 5. Card margin (bottom only)
    final cardMargin = spacing;

    // Total height calculation
    final totalHeight =
        totalCardPadding +
        titleRowHeight +
        spacingAfterTitle +
        totalItemsHeight +
        cardMargin;

    return totalHeight;
  }

  @override
  Widget build(BuildContext context) {
    final adPanel = adPanels.first;
    final hasBeenEdited = adPanels.any((panel) => panel.hasBeenEdited);

    return DsCardWidget(
      backgroundColor: hasBeenEdited
          ? context.colorPalette.brand.secondary
          : context.colorPalette.invertedBackground.primary,
      radius: context.dimen.radiusLevel2,
      elevation: context.dimen.elevationLevel1,
      margin: EdgeInsets.only(bottom: context.space()),
      onTap: () {
        context.push(AdPanelModuleRoute.adPanel.path, extra: adPanels);
      },
      child: Padding(
        padding: EdgeInsets.all(
          context.space(factor: context.isMobile ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DSTextWidget(
                    adPanel.objectNumber,
                    color: hasBeenEdited
                        ? context.colorPalette.brand.onSecondary
                        : context.colorPalette.neutral.grey1,
                    style: context.typography.titleMedium,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                DSIconWidget(
                  Icons.arrow_forward_ios,
                  size: DSIconSize.small,
                  color: hasBeenEdited
                      ? context.colorPalette.brand.onSecondary
                      : context.colorPalette.neutral.grey1,
                ),
              ],
            ),
            SizedBox(height: context.space(factor: 0.5)),
            _ItemWidget(
              icon: Icons.directions,
              label: adPanel.street.capitalize,
              hasBeenEdited: hasBeenEdited,
            ),
            _ItemWidget(
              icon: Icons.location_city_rounded,
              label: adPanel.municipalityPart.capitalize,
              hasBeenEdited: hasBeenEdited,
            ),
            _ItemWidget(
              icon: Icons.ad_units_rounded,
              label: context.localizations.adPanelFaceCount(adPanels.length),
              hasBeenEdited: hasBeenEdited,
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.icon,
    required this.label,
    required this.hasBeenEdited,
  });

  final IconData icon;
  final String label;
  final bool hasBeenEdited;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DSIconWidget(
          icon,
          size: DSIconSize.small,
          color: hasBeenEdited
              ? context.colorPalette.brand.onSecondary
              : context.colorPalette.neutral.grey4,
        ),
        const DSHorizontalSpacerWidget(0.5),
        Flexible(
          child: DSTextWidget(
            label,
            color: hasBeenEdited
                ? context.colorPalette.brand.onSecondary
                : context.colorPalette.neutral.grey4,
            style: context.typography.bodyMedium,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
