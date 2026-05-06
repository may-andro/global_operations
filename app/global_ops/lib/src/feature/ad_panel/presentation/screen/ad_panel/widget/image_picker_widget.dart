import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/file_picker/file_picker.dart';

class ImagePickerWidget extends StatelessWidget {
  const ImagePickerWidget({super.key});

  static Future<ImagePickerSource?> _showAsBottomSheet(BuildContext context) {
    return showModalBottomSheet<ImagePickerSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const DSBottomSheetWidget(child: ImagePickerWidget()),
    );
  }

  static Future<ImagePickerSource?> _showAsDialog(BuildContext context) {
    return showDialog<ImagePickerSource>(
      context: context,
      builder: (_) => const DSDialogWidget(child: ImagePickerWidget()),
    );
  }

  static Future<ImagePickerSource?> showAsDialogOrBottomSheet(
    BuildContext context,
  ) {
    if (context.isDesktop) {
      return _showAsDialog(context);
    }

    return _showAsBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              context.localizations.adPanelSelectImageSource,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: DSTextWidget(
                context.localizations.adPanelCamera,
                style: context.typography.bodyMedium,
                color: context.colorPalette.background.onPrimary,
              ),
              onTap: () => Navigator.of(context).pop(ImagePickerSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: DSTextWidget(
                context.localizations.adPanelGallery,
                style: context.typography.bodyMedium,
                color: context.colorPalette.background.onPrimary,
              ),
              onTap: () => Navigator.of(context).pop(ImagePickerSource.gallery),
            ),
          ],
        ),
      ),
    );
  }
}
