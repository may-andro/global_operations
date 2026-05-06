import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';

class ImageCompressionProgressWidget extends StatelessWidget {
  const ImageCompressionProgressWidget({super.key});

  static Future<void> _showAsBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) {
        return const PopScope(
          canPop: false,
          child: DSBottomSheetWidget(child: ImageCompressionProgressWidget()),
        );
      },
    );
  }

  static Future<void> _showAsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return const PopScope(
          canPop: false,
          child: DSDialogWidget(child: ImageCompressionProgressWidget()),
        );
      },
    );
  }

  static Future<void> showAsDialogOrBottomSheet(BuildContext context) {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              context.localizations.imageCompressionTitle,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            DSTextWidget(
              context.localizations.imageCompressionMessage,
              style: context.typography.bodyMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            DSLoadingWidget(size: context.space(factor: 5)),
          ],
        ),
      ),
    );
  }
}
