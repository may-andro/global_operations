import 'dart:math';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class StaticFormCardWidget extends StatelessWidget {
  const StaticFormCardWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: context.getFormCardWidth(constraints),
            maxHeight: constraints.maxHeight,
          ),
          child: DsCardWidget(
            backgroundColor: context.colorPalette.background.primary,
            elevation: context.dimen.elevationLevel3,
            radius: context.dimen.radiusLevel2,
            child: Padding(
              padding: EdgeInsets.all(context.space(factor: 3)),
              child: child,
            ),
          ),
        );
      },
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
        return max(500.0, constraints.maxWidth * 0.6);
      case DSDeviceWidthResolution.xl:
        return max(600.0, constraints.maxWidth * 0.6);
    }
  }
}
