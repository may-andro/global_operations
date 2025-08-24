import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';
import 'package:global_ops/src/route/route.dart';

class ExitWarningWidget extends StatelessWidget {
  const ExitWarningWidget({super.key});

  static Future<bool?> _showAsBottomSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        return BlocProvider.value(
          value: context.read<AdPanelBloc>(),
          child: const DSBottomSheetWidget(child: ExitWarningWidget()),
        );
      },
    );
  }

  static Future<bool?> _showAsDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<AdPanelBloc>(),
          child: const DSDialogWidget(child: ExitWarningWidget()),
        );
      },
    );
  }

  static Future<bool?> showAsDialogOrBottomSheet(BuildContext context) {
    if (context.isDesktop) {
      return _showAsDialog(context);
    }

    return _showAsBottomSheet(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AdPanelBloc, AdPanelState>(
      listener: (context, state) {
        switch (state) {
          case AdPanelErrorState():
          case AdPanelUploadErrorState():
          case AdPanelUpdateErrorState():
          case AdPanelSuccessState():
            context.pop();
          default:
            // Do nothing for other states
            break;
        }
      },
      builder: (context, state) {
        final message = _getMessageForState(state, context);
        final isProcessing = _isProcessingState(state);

        return SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DSVerticalSpacerWidget(1),
                DSTextWidget(
                  isProcessing
                      ? context
                            .localizations
                            .adPanelUpdateProcessingWarningTitleUnsavedChanges
                      : context
                            .localizations
                            .adPanelUpdateExistWarningTitleUnsavedChanges,
                  style: context.typography.titleMedium,
                  color: context.colorPalette.background.onPrimary,
                ),
                const DSVerticalSpacerWidget(2),
                DSTextWidget(
                  message,
                  style: context.typography.bodyMedium,
                  color: context.colorPalette.background.onPrimary,
                ),
                const DSVerticalSpacerWidget(3),
                if (isProcessing) ...[
                  Center(
                    child: DSLoadingWidget(size: context.space(factor: 3)),
                  ),
                ] else ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DSButtonWidget(
                        label: context.localizations.yes,
                        onPressed: () => Navigator.of(context).pop(true),
                        size: DSButtonSize.small,
                        variant: DSButtonVariant.secondary,
                      ),
                      const DSHorizontalSpacerWidget(1),
                      DSButtonWidget(
                        label: context.localizations.no,
                        onPressed: () => Navigator.of(context).pop(false),
                        size: DSButtonSize.small,
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _getMessageForState(AdPanelState state, BuildContext context) {
    return switch (state) {
      AdPanelImageCompressionProgressState() =>
        context.localizations.imageCompressionMessage,
      AdPanelImageUploadProgressState() =>
        context.localizations.adPanelUpdateExistWarningUploadingImages,
      AdPanelUpdatingPanelsState() =>
        context.localizations.adPanelUpdateExistWarningUpdatingPanels,
      AdPanelsLoadedState() when state.hasBeenEdited =>
        context.localizations.adPanelUpdateExistWarningUnsavedChanges,
      _ => context.localizations.adPanelUpdateExistWarningUnsavedChanges,
    };
  }

  bool _isProcessingState(AdPanelState state) {
    return switch (state) {
      AdPanelImageCompressionProgressState() ||
      AdPanelImageUploadProgressState() ||
      AdPanelUpdatingPanelsState() => true,
      _ => false,
    };
  }
}
