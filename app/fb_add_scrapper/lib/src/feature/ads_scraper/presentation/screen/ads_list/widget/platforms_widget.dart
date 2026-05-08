import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/extension/platform_extension.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlatformsWidget extends StatelessWidget {
  const PlatformsWidget({super.key, required this.platforms});

  final List<String> platforms;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.space(),
      children: platforms
          .map((platform) => _PlatformWidget(platform: platform))
          .toList(),
    );
  }
}

class _PlatformWidget extends StatelessWidget {
  const _PlatformWidget({required this.platform});

  final String platform;

  @override
  Widget build(BuildContext context) {
    final size = DSIconWidget.getHeight(context, DSIconSize.small);
    final icon = platform.platformIcon;

    if (icon == null) {
      return const SizedBox.shrink();
    }
    return FaIcon(
      icon,
      color: context.colorPalette.neutral.grey3.color,
      size: size,
    );
  }
}
