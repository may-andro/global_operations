import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';

class AnimatedIconWidget extends StatelessWidget {
  const AnimatedIconWidget({super.key, this.icon, this.iconAsset});

  final IconData? icon;
  final DSSvgAssetImage? iconAsset;

  @override
  Widget build(BuildContext context) {
    final size = context.iconSizeFactor;
    Widget iconWidget = const SizedBox.shrink();

    if (icon case final IconData icon) {
      iconWidget = Icon(
        icon,
        size: size,
        color: context.colorPalette.neutral.white.color,
      );
    }

    if (iconAsset case final DSSvgAssetImage iconAsset) {
      iconWidget = DSSvgImageWidget(
        assetImage: iconAsset,
        width: size,
        height: size,
      );
    }

    return iconWidget
        .animate()
        .scale(duration: 800.ms, curve: Curves.elasticOut)
        .then()
        .shimmer(
          duration: 1500.ms,
          color: context.colorPalette.brand.primary.color.withValues(
            alpha: 0.3,
          ),
        );
  }
}

extension on BuildContext {
  double get iconSizeFactor {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return space(factor: 10);
      case DSDeviceWidthResolution.s:
        return space(factor: 8);
      case DSDeviceWidthResolution.m:
        return width * 0.125;
      case DSDeviceWidthResolution.l:
        return width * 0.15;
      case DSDeviceWidthResolution.xl:
        return width * 0.2;
    }
  }
}
