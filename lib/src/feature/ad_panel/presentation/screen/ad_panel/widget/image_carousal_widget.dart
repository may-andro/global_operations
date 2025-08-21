import 'dart:io';

import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/image_picker_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/widget/max_image_warning_widget.dart';
import 'package:global_ops/src/feature/file_picker/file_picker.dart';

class ImageCarousalWidget extends StatelessWidget {
  const ImageCarousalWidget({
    super.key,
    required this.index,
    required this.adPanel,
    required this.filesToUpload,
    required this.rawFilesToUpload,
  });

  final int index;
  final AdPanelEntity adPanel;
  final List<File> filesToUpload;
  final List<Uint8List> rawFilesToUpload;

  @override
  Widget build(BuildContext context) {
    final networkImage = adPanel.images ?? [];
    final totalItems =
        filesToUpload.length + rawFilesToUpload.length + networkImage.length;

    return SizedBox(
      height: context.space(factor: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: totalItems + 1,
        separatorBuilder: (_, _) => const DSHorizontalSpacerWidget(1),
        itemBuilder: (context, i) {
          Widget? itemWidget;

          if (i == 0) {
            itemWidget = _ButtonItemWidget(
              adPanel: adPanel,
              index: index,
              totalItems: totalItems - 1,
            );
          } else if (i <= filesToUpload.length) {
            final fileIndex = i - 1;
            final file = filesToUpload[fileIndex];
            itemWidget = _ImageFileItemWidget(
              file: file,
              adPanel: adPanel,
              index: index,
            );
          } else if (i <= filesToUpload.length + rawFilesToUpload.length) {
            final fileIndex = i - 1 - filesToUpload.length;
            final rawFile = rawFilesToUpload[fileIndex];
            itemWidget = _RawImageItemWidget(
              rawFile: rawFile,
              adPanel: adPanel,
              index: index,
            );
          } else {
            final urlIndex =
                i - 1 - filesToUpload.length - rawFilesToUpload.length;
            final url = networkImage[urlIndex];
            itemWidget = _NetworkImageItemWidget(
              url: url,
              adPanel: adPanel,
              index: index,
            );
          }

          return DsCardWidget(
            backgroundColor: context.colorPalette.invertedBackground.primary,
            radius: context.dimen.radiusLevel2,
            child: SizedBox(
              width: context.space(factor: context.isDesktop ? 15 : 20),
              child: itemWidget,
            ),
          );
        },
      ),
    );
  }
}

class _ButtonItemWidget extends StatelessWidget {
  const _ButtonItemWidget({
    required this.adPanel,
    required this.index,
    required this.totalItems,
  });

  final AdPanelEntity adPanel;
  final int index;
  final int totalItems;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (totalItems >= 3) {
          await MaxImageWarningWidget.showAsDialogOrBottomSheet(context);
          return;
        }

        if (kIsWeb) {
          if (context.mounted) {
            context.read<AdPanelBloc>().add(
              PickImageFileOnWebEvent(index: index, adPanel: adPanel),
            );
          }
        } else {
          final source = await ImagePickerWidget.showAsDialogOrBottomSheet(
            context,
          );
          if (context.mounted) {
            context.read<AdPanelBloc>().add(
              PickImageFileOnMobileEvent(
                index: index,
                adPanel: adPanel,
                imagePickerSource: source ?? ImagePickerSource.gallery,
              ),
            );
          }
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
}

class _NetworkImageItemWidget extends StatelessWidget {
  const _NetworkImageItemWidget({
    required this.url,
    required this.adPanel,
    required this.index,
  });

  final String url;
  final AdPanelEntity adPanel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: DSNetworkImageWidget(url: url, fit: BoxFit.cover),
        ),
        Positioned(
          right: context.space(factor: 0.5),
          top: context.space(factor: 0.5),
          child: GestureDetector(
            onTap: () {
              context.read<AdPanelBloc>().add(
                DeleteImageEvent(index: index, adPanel: adPanel, url: url),
              );
            },
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

class _ImageFileItemWidget extends StatelessWidget {
  const _ImageFileItemWidget({
    required this.file,
    required this.adPanel,
    required this.index,
  });

  final File file;
  final AdPanelEntity adPanel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.file(file, fit: BoxFit.cover)),
        Positioned(
          right: context.space(factor: 0.5),
          top: context.space(factor: 0.5),
          child: GestureDetector(
            onTap: () {
              context.read<AdPanelBloc>().add(
                DeleteImageEvent(index: index, adPanel: adPanel, file: file),
              );
            },
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

class _RawImageItemWidget extends StatelessWidget {
  const _RawImageItemWidget({
    required this.rawFile,
    required this.adPanel,
    required this.index,
  });

  final Uint8List rawFile;
  final AdPanelEntity adPanel;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: Image.memory(rawFile, fit: BoxFit.cover)),
        Positioned(
          right: context.space(factor: 0.5),
          top: context.space(factor: 0.5),
          child: GestureDetector(
            onTap: () {
              context.read<AdPanelBloc>().add(
                DeleteImageEvent(
                  index: index,
                  adPanel: adPanel,
                  rawFile: rawFile,
                ),
              );
            },
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
