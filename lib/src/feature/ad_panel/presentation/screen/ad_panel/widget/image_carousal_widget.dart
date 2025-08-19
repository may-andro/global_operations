import 'dart:async';
import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/image_picker_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/max_image_warning_widget.dart';
import 'package:image_picker/image_picker.dart';

class ImageCarousalWidget extends StatelessWidget {
  const ImageCarousalWidget({
    super.key,
    required this.adPanel,
    required this.index,
  });

  final AdPanelEntity adPanel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final images = adPanel.images ?? [];
    return SizedBox(
      height: context.space(factor: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: images.length + 1,
        separatorBuilder: (_, _) => const DSHorizontalSpacerWidget(1),
        itemBuilder: (context, i) {
          return DsCardWidget(
            backgroundColor: context.colorPalette.invertedBackground.primary,
            radius: context.dimen.radiusLevel2,
            child: SizedBox(
              width: context.space(factor: 20),
              child: i == 0
                  ? _ButtonItemWidget(adPanel: adPanel, index: index)
                  : _ImageItemWidget(
                      imagePath: images[i - 1],
                      onDelete: () {
                        final updatedImages = List<String>.from(images)
                          ..removeAt(i - 1);
                        final updatedPanel = adPanel.copyWith(
                          images: updatedImages,
                        );
                        context.read<AdPanelBloc>().add(
                          EditAdPanelEvent(index, updatedPanel),
                        );
                        context.read<AdPanelBloc>().add(
                          DeleteImageEvent(images[i - 1]),
                        );
                      },
                    ),
            ),
          );
        },
      ),
    );
  }
}

class _ButtonItemWidget extends StatelessWidget {
  const _ButtonItemWidget({required this.adPanel, required this.index});

  final AdPanelEntity adPanel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final images = adPanel.images ?? [];
        if (images.length >= 3) {
          await MaxImageWarningWidget.showAsDialogOrBottomSheet(context);
          return;
        }

        final source = await ImagePickerWidget.showAsDialogOrBottomSheet(
          context,
        );
        if (source == null) return;
        if (context.mounted) {
          await _pickImage(context, source);
        }
      },
      child: Center(
        child: DSCircularIconCardWidget(
          icon: Icons.add_a_photo,
          backgroundColor: context.colorPalette.invertedBackground.onPrimary,
          color: context.colorPalette.invertedBackground.primary,
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      final updatedImages = List<String>.from(adPanel.images ?? [])
        ..add(pickedFile.path);
      final updatedPanel = adPanel.copyWith(images: updatedImages);
      if (context.mounted) {
        context.read<AdPanelBloc>().add(EditAdPanelEvent(index, updatedPanel));
      }
    }
  }
}

class _ImageItemWidget extends StatelessWidget {
  const _ImageItemWidget({required this.imagePath, required this.onDelete});

  final String imagePath;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final isUrl = imagePath.startsWith('http');
    return Stack(
      children: [
        Positioned.fill(
          child: isUrl
              ? DSNetworkImageWidget(url: imagePath, fit: BoxFit.cover)
              : Image.file(File(imagePath), fit: BoxFit.cover),
        ),
        Positioned(
          right: context.space(factor: 0.5),
          top: context.space(factor: 0.5),
          child: GestureDetector(
            onTap: onDelete,
            child: DSCircularIconCardWidget(
              icon: Icons.delete,
              backgroundColor:
                  context.colorPalette.invertedBackground.onPrimary,
              color: context.colorPalette.invertedBackground.primary,
            ),
          ),
        ),
      ],
    );
  }
}
