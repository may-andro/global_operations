import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/route/route.dart';

class UploadFailureWidget extends StatelessWidget {
  const UploadFailureWidget({super.key, required this.failedFilesCount});

  final int failedFilesCount;

  static Future<bool?> _showAsBottomSheet(
    BuildContext context,
    int failedFilesCount,
  ) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DSBottomSheetWidget(
          child: UploadFailureWidget(failedFilesCount: failedFilesCount),
        );
      },
    );
  }

  static Future<bool?> _showAsDialog(
    BuildContext context,
    int failedFilesCount,
  ) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return DSDialogWidget(
          child: UploadFailureWidget(failedFilesCount: failedFilesCount),
        );
      },
    );
  }

  static Future<bool?> showAsDialogOrBottomSheet(
    BuildContext context,
    int failedFilesCount,
  ) {
    if (context.isDesktop) {
      return _showAsDialog(context, failedFilesCount);
    }

    return _showAsBottomSheet(context, failedFilesCount);
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
                failedFilesCount,
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
