import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:go_router/go_router.dart';

class MaxImageWarningWidget extends StatelessWidget {
  const MaxImageWarningWidget({super.key});

  static Future<void> _showAsBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => const DSBottomSheetWidget(child: MaxImageWarningWidget()),
    );
  }

  static Future<void> _showAsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (_) => const DSDialogWidget(child: MaxImageWarningWidget()),
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
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              context.localizations.adPanelAllowedImageMaxLengthMessage,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            DSTextWidget(
              context.localizations.adPanelAllowedImageMaxLengthMessage,
              style: context.typography.bodyMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            Align(
              alignment: Alignment.bottomRight,
              child: FittedBox(
                child: DSButtonWidget(
                  label: context.localizations.close,
                  onPressed: () => context.pop(),
                  variant: DSButtonVariant.secondary,
                  size: DSButtonSize.small,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
