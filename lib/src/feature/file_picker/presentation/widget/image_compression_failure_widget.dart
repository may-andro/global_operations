import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/file_picker/domain/domain.dart';
import 'package:global_ops/src/feature/file_picker/presentation/extension/image_compression_failure_message_extension.dart';
import 'package:global_ops/src/route/route.dart';

class ImageCompressionFailureWidget extends StatelessWidget {
  const ImageCompressionFailureWidget({super.key, this.message});

  final String? message;

  static Future<void> _showAsBottomSheet(
    BuildContext context, {
    required ImagePickerFailure? imagePickerFailure,
    required FilePickerFailure? filePickerFailure,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DSBottomSheetWidget(
          child: ImageCompressionFailureWidget(
            message:
                imagePickerFailure?.getMessage(context) ??
                filePickerFailure?.getMessage(context),
          ),
        );
      },
    );
  }

  static Future<void> _showAsDialog(
    BuildContext context, {
    required ImagePickerFailure? imagePickerFailure,
    required FilePickerFailure? filePickerFailure,
  }) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return DSDialogWidget(
          child: ImageCompressionFailureWidget(
            message:
                imagePickerFailure?.getMessage(context) ??
                filePickerFailure?.getMessage(context),
          ),
        );
      },
    );
  }

  static Future<void> showAsDialogOrBottomSheet(
    BuildContext context, {
    required ImagePickerFailure? imagePickerFailure,
    required FilePickerFailure? filePickerFailure,
  }) {
    if (context.isDesktop) {
      return _showAsDialog(
        context,
        imagePickerFailure: imagePickerFailure,
        filePickerFailure: filePickerFailure,
      );
    }

    return _showAsBottomSheet(
      context,
      imagePickerFailure: imagePickerFailure,
      filePickerFailure: filePickerFailure,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              context.localizations.imageCompressionFailureTitle,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            DSTextWidget(
              message ?? context.localizations.errorUnknownFile,
              style: context.typography.bodyMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            FittedBox(
              child: DSButtonWidget(
                label: context.localizations.close,
                onPressed: () {
                  context.pop();
                },
                variant: DSButtonVariant.secondary,
                size: DSButtonSize.small,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
