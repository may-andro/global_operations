import 'package:design_system/src/component/atom/ds_svg_image_widget.dart';
import 'package:design_system/src/extension/build_context_extension.dart';
import 'package:design_system/src/foundation/foundation.dart';
import 'package:flutter/material.dart';

class DSLogoImageWidget extends StatelessWidget {
  const DSLogoImageWidget._({this.height, this.width, this.fit, this.color});

  factory DSLogoImageWidget.square({double? size, DSColor? color}) {
    return DSLogoImageWidget._(height: size, width: size, color: color);
  }

  factory DSLogoImageWidget.rectangle({
    double? height,
    double? width,
    BoxFit? fit,
    DSColor? color,
  }) {
    return DSLogoImageWidget._(
      height: height,
      width: width,
      fit: fit,
      color: color,
    );
  }

  final double? height;
  final double? width;
  final BoxFit? fit;
  final DSColor? color;

  @override
  Widget build(BuildContext context) {
    return DSSvgImageWidget(
      assetImage: context.isDarkMode
          ? DSSvgAssetImage.logoDark
          : DSSvgAssetImage.logoLight,
      fit: fit ?? BoxFit.cover,
      width: height,
      height: width,
      colorFilter: color != null
          ? ColorFilter.mode(color!.color, BlendMode.srcIn)
          : null,
    );
  }
}

class DSIconLogoImageWidget extends StatelessWidget {
  const DSIconLogoImageWidget({this.size = 120, super.key});

  final double size;

  @override
  Widget build(BuildContext context) {
    return DSSvgImageWidget(
      assetImage: context.isDarkMode
          ? DSSvgAssetImage.iconLogoDark
          : DSSvgAssetImage.iconLogoLight,
      fit: BoxFit.cover,
      width: size,
      height: size,
    );
  }
}
