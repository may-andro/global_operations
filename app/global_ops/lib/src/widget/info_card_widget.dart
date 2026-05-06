import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class InfoCardWidget extends StatelessWidget {
  const InfoCardWidget({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    this.action,
    this.actionIcon,
    this.onPressed,
    super.key,
  });

  final IconData icon;
  final DSColor iconColor;
  final String title;
  final String description;
  final String? action;
  final IconData? actionIcon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: context.getFormCardWidth(constraints),
              maxHeight: constraints.maxHeight,
            ),
            child: DsCardWidget(
              backgroundColor: context.colorPalette.background.inverseSurface,
              elevation: context.dimen.elevationLevel1,
              radius: context.dimen.radiusLevel2,
              margin: EdgeInsets.all(
                context.space(factor: context.isMobile ? 3 : 0),
              ),
              child: Padding(
                padding: EdgeInsets.all(context.space(factor: 3)),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        icon,
                        color: iconColor.color,
                        size: context.space(factor: 6),
                      ),
                      const DSVerticalSpacerWidget(2),
                      DSTextWidget(
                        title,
                        style: context.typography.titleLarge,
                        color: context.colorPalette.background.onInverseSurface,
                      ),
                      const DSVerticalSpacerWidget(1),
                      DSTextWidget(
                        description,
                        textAlign: TextAlign.center,
                        style: context.typography.bodyMedium,
                        color: context.colorPalette.background.onInverseSurface,
                      ),
                      const DSVerticalSpacerWidget(3),
                      if (action case final String action)
                        if (onPressed case final VoidCallback onPressed)
                          DSButtonWidget(
                            label: action,
                            icon: actionIcon,
                            onPressed: onPressed,
                          ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

extension on BuildContext {
  double getFormCardWidth(BoxConstraints constraints) {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return 400;
      case DSDeviceWidthResolution.s:
        return 450;
      case DSDeviceWidthResolution.m:
        return max(450.0, constraints.maxWidth * 0.6);
      case DSDeviceWidthResolution.l:
        return max(500.0, constraints.maxWidth * 0.5);
      case DSDeviceWidthResolution.xl:
        return max(600.0, constraints.maxWidth * 0.4);
    }
  }
}
