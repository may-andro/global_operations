import 'package:design_system/src/component/atom/atom.dart';
import 'package:design_system/src/extension/build_context_extension.dart';
import 'package:design_system/src/foundation/foundation.dart';
import 'package:flutter/material.dart';

class DSAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const DSAppBarWidget({
    super.key,
    required this.height,
    this.onBackClicked,
    this.backgroundColor,
    this.actions,
  });

  final double height;
  final VoidCallback? onBackClicked;
  final DSColor? backgroundColor;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    if (context.isDesktop) return const SizedBox.shrink();

    return AppBar(
      backgroundColor:
          backgroundColor?.color ??
          context.colorPalette.background.primary.color,
      surfaceTintColor: context.colorPalette.neutral.transparent.color,
      shadowColor:
          backgroundColor?.color ??
          context.colorPalette.background.onPrimary.color,
      centerTitle: true,
      toolbarHeight: height,
      elevation: 0,
      scrolledUnderElevation: 0,
      leading: onBackClicked != null
          ? DSIconButtonWidget(
              Icons.close,
              iconColor: context.colorPalette.background.onPrimary,
              buttonColor: context.colorPalette.background.primary,
              onPressed: onBackClicked!,
              size: _getIconSize(context),
            )
          : null,
      title: DSLogoImageWidget.rectangle(height: height),
      actions: actions,
    );
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(height);
  }

  static double getHeight(BuildContext context) {
    switch (context.deviceResolution) {
      case DSDeviceResolution.mobile:
        return context.space(factor: 7);
      case DSDeviceResolution.tablet:
        return context.space(factor: 7);
      case DSDeviceResolution.desktop:
        return context.space(factor: 8);
    }
  }

  DSIconButtonSize _getIconSize(BuildContext context) {
    switch (context.deviceResolution) {
      case DSDeviceResolution.mobile:
      case DSDeviceResolution.tablet:
        return DSIconButtonSize.medium;
      case DSDeviceResolution.desktop:
        return DSIconButtonSize.small;
    }
  }
}
