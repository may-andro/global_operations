import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/submit_button_widget.dart';

class FlexibleSpaceWidget extends StatelessWidget {
  const FlexibleSpaceWidget({required this.adPanel, super.key});

  final AdPanelEntity adPanel;

  static double height(BuildContext context) {
    const logoHeight = kToolbarHeight;
    // top + bottom padding
    final cardVerticalPadding = context.space(factor: 2) * 2;
    // card padding
    final cardInternalPadding = context.space(factor: 2) * 2;
    // spacing between content
    final contentSpacing = context.space(factor: context.isDesktop ? 0 : 4);
    // Calculate item height based on text style and text scale factor
    final itemTextHeight = context.getTextHeight(
      context.typography.bodyMedium,
      1,
    );
    final itemIconHeight = DSIconWidget.getHeight(context, DSIconSize.medium);
    // Calculate the maximum height of the item based on text and icon
    final itemHeight = max(itemTextHeight, itemIconHeight);
    // Calculate the height of the title text
    final titleTextHeight = context.getTextHeight(
      context.typography.titleLarge,
      1,
    );
    final titleIconHeight = DSCircularIconCardWidget.getHeight(context);
    // Calculate the maximum height of the title based on text and icon
    final titleHeight = max(titleTextHeight, titleIconHeight);
    // Title padding
    final titlePadding = context.space();

    return logoHeight +
        cardVerticalPadding +
        cardInternalPadding +
        contentSpacing +
        (context.isDesktop ? itemHeight : itemHeight * 3) +
        titleHeight +
        titlePadding;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.space(factor: 2)),
      child: DsCardWidget(
        backgroundColor: context.colorPalette.invertedBackground.primary,
        radius: context.dimen.radiusLevel2,
        child: Padding(
          padding: EdgeInsets.all(context.space(factor: 2)),
          child: SingleChildScrollView(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TitleWidget(adPanel: adPanel),
                      DSVerticalSpacerWidget(context.isDesktop ? 1 : 2),
                      _WrappedItemWidget(adPanel: adPanel),
                    ],
                  ),
                ),
                const SubmitButtonWidget(isInAppBar: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TitleWidget extends StatelessWidget {
  const _TitleWidget({required this.adPanel});

  final AdPanelEntity adPanel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DSCircularIconCardWidget(
          icon: Icons.ad_units_rounded,
          backgroundColor: context.colorPalette.invertedBackground.onPrimary,
          color: context.colorPalette.invertedBackground.primary,
        ),
        const DSHorizontalSpacerWidget(1),
        Flexible(
          child: DSTextWidget(
            adPanel.objectNumber,
            color: context.colorPalette.invertedBackground.onPrimary,
            style: context.typography.titleLarge,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _WrappedItemWidget extends StatelessWidget {
  const _WrappedItemWidget({required this.adPanel});

  final AdPanelEntity adPanel;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 300.milliseconds,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: context.isDesktop
          ? Wrap(
              spacing: context.space(factor: 2),
              children: [
                _ItemWidget(icon: Icons.my_location, label: adPanel.street),
                _ItemWidget(
                  icon: Icons.business_rounded,
                  label: adPanel.station,
                ),
                _ItemWidget(
                  icon: Icons.location_city_rounded,
                  label: adPanel.municipalityPart,
                ),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ItemWidget(icon: Icons.my_location, label: adPanel.street),
                const DSVerticalSpacerWidget(1),
                _ItemWidget(
                  icon: Icons.business_rounded,
                  label: adPanel.station,
                ),
                const DSVerticalSpacerWidget(1),
                _ItemWidget(
                  icon: Icons.location_city_rounded,
                  label: adPanel.municipalityPart,
                ),
              ],
            ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DSIconWidget(
          icon,
          color: context.colorPalette.invertedBackground.onPrimary,
          size: DSIconSize.medium,
        ),
        const DSHorizontalSpacerWidget(1),
        Flexible(
          child: DSTextWidget(
            label,
            color: context.colorPalette.invertedBackground.onPrimary,
            style: context.typography.bodyMedium,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
