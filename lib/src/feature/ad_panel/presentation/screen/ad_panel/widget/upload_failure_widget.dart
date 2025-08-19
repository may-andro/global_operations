import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/route/route.dart';

class UploadFailureWidget extends StatelessWidget {
  const UploadFailureWidget({super.key, required this.failedFiles});

  final List<String> failedFiles;

  static Future<bool?> _showAsBottomSheet(
    BuildContext context,
    List<String> failedFiles,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DSBottomSheetWidget(
          child: UploadFailureWidget(failedFiles: failedFiles),
        );
      },
    );
  }

  static Future<bool?> _showAsDialog(
    BuildContext context,
    List<String> failedFiles,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return DSDialogWidget(
          child: UploadFailureWidget(failedFiles: failedFiles),
        );
      },
    );
  }

  static Future<bool?> showAsDialogOrBottomSheet(
    BuildContext context,
    List<String> failedFiles,
  ) {
    if (context.isDesktop) {
      return _showAsDialog(context, failedFiles);
    }

    return _showAsBottomSheet(context, failedFiles);
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
              context.localizations.adPanelImageUpdateFailureTitle,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            DSTextWidget(
              context.localizations.adPanelImageUpdateFailureMessage(
                failedFiles.length,
              ),
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
