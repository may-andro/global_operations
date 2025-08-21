import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/ad_panel.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/checkbox_list_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/comment_text_field_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/image_carousal_widget.dart';

class FaceTabContentWidget extends StatelessWidget {
  const FaceTabContentWidget({
    required this.index,
    required this.adPanel,
    required this.filesToUpload,
    required this.rawFilesToUpload,
    super.key,
  });

  final int index;
  final AdPanelEntity adPanel;
  final List<File> filesToUpload;
  final List<Uint8List> rawFilesToUpload;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(context.space(factor: 2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DSTextWidget(
            context.localizations.adPanelRunningCampaign(adPanel.campaign),
            style: context.typography.titleMedium,
            color: context.colorPalette.background.onPrimary,
          ),
          const DSVerticalSpacerWidget(2),
          CheckboxListWidget(adPanel: adPanel, index: index),
          const DSVerticalSpacerWidget(2),
          DSTextWidget(
            context.localizations.adPanelAdditionalComments,
            style: context.typography.titleMedium,
            color: context.colorPalette.background.onPrimary,
          ),
          const DSVerticalSpacerWidget(1),
          CommentTextFieldWidget(adPanel: adPanel, index: index),
          const DSVerticalSpacerWidget(2),
          Row(
            children: [
              DSTextWidget(
                'Add Images',
                style: context.typography.titleMedium,
                color: context.colorPalette.background.onPrimary,
              ),
              const Spacer(),
              Chip(
                backgroundColor:
                    context.colorPalette.invertedBackground.primary.color,
                label: DSTextWidget(
                  'Max 3 photos',
                  style: context.typography.labelSmall,
                  color: context.colorPalette.invertedBackground.onPrimary,
                ),
              ),
            ],
          ),
          const DSVerticalSpacerWidget(1),
          ImageCarousalWidget(
            index: index,
            adPanel: adPanel,
            filesToUpload: filesToUpload,
            rawFilesToUpload: rawFilesToUpload,
          ),
        ],
      ),
    );
  }
}
