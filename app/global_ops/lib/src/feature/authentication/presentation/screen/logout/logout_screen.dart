import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/logout/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  static Future<bool?> _showAsBottomSheet(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return const DSBottomSheetWidget(child: LogoutScreen());
      },
    );
  }

  static Future<bool?> _showAsDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return const DSDialogWidget(child: LogoutScreen());
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
    return BlocProvider(
      create: (_) => appServiceLocator.get<LogoutBloc>(),
      child: Builder(
        builder: (context) => BlocConsumer<LogoutBloc, LogoutState>(
          listener: (context, state) {
            switch (state.runtimeType) {
              case final LogoutSuccessState _:
                Navigator.pop(context, true);
              case final LogoutFailureState state:
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));
              default:
                break;
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const DSVerticalSpacerWidget(1),
                    DSTextWidget(
                      context.localizations.settingLogoutConfirmation,
                      style: context.typography.titleMedium,
                      color: context.colorPalette.background.onPrimary,
                    ),
                    const DSVerticalSpacerWidget(2),
                    DSTextWidget(
                      context.localizations.settingLogoutConfirmationPrompt,
                      style: context.typography.bodyMedium,
                      color: context.colorPalette.background.onPrimary,
                    ),
                    const DSVerticalSpacerWidget(2),
                    Row(
                      children: [
                        const Spacer(),
                        DSButtonWidget(
                          label: context.localizations.yes,
                          onPressed: () {
                            context.read<LogoutBloc>().add(
                              LogoutRequestedEvent(),
                            );
                          },
                          variant: DSButtonVariant.secondary,
                          size: DSButtonSize.small,
                          isLoading: state is LogoutInProgressState,
                        ),
                        const DSHorizontalSpacerWidget(2),
                        DSButtonWidget(
                          label: context.localizations.no,
                          onPressed: () => Navigator.pop(context, false),
                          variant: DSButtonVariant.secondary,
                          size: DSButtonSize.small,
                          isLoading: state is LogoutInProgressState,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
