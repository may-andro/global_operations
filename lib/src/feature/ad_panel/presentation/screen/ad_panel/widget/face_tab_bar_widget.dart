import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

class FaceTabBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const FaceTabBarWidget({
    required this.tabController,
    required this.adPanels,
    super.key,
  });

  final TabController tabController;
  final List<AdPanelEntity> adPanels;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorPalette.background.primary.color,
      child: TabBar(
        controller: tabController,
        isScrollable: kIsWeb,
        tabs: [
          for (final panel in adPanels)
            Tab(
              child: DSTextWidget(
                context.localizations.adPanelFaceLabel(panel.faceNumber),
                color: context.colorPalette.background.onPrimary,
                style: context.typography.bodyMedium,
              ),
            ),
        ],
      ),
    );
  }
}
