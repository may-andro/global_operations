import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/locale/domain/domain.dart';
import 'package:global_ops/src/feature/locale/presentation/extension/extension.dart';
import 'package:global_ops/src/feature/locale/presentation/extension/locale_failure_message_extension.dart';
import 'package:global_ops/src/feature/locale/presentation/route/locale_module_route.dart';
import 'package:global_ops/src/feature/locale/presentation/screen/locale_selection/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';
import 'package:global_ops/src/route/route.dart';

class LocaleSelectionScreen extends StatelessWidget {
  const LocaleSelectionScreen({super.key, this.isDialog = false});

  final bool isDialog;

  static void navigate(BuildContext context) {
    context.push(LocaleModuleRoute.localeSelection.path);
  }

  static Future<void> showAsDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return DSDialogWidget(
          child: IntrinsicHeight(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Flexible(child: LocaleSelectionScreen(isDialog: true)),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: DSButtonWidget(
                    label: context.localizations.close,
                    onPressed: context.pop,
                    variant: DSButtonVariant.secondary,
                    size: DSButtonSize.small,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          appServiceLocator.get<LocaleSelectionBloc>()
            ..add(const LoadLocaleEvent()),
      child: BlocConsumer<LocaleSelectionBloc, LocaleSelectionState>(
        listener: _handleStateChanges,
        builder: (context, state) {
          final content = SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(context.space(factor: 2)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DSVerticalSpacerWidget(1),
                  DSTextWidget(
                    context.localizations.localeSelectLanguage,
                    style: isDialog
                        ? context.typography.headlineSmall
                        : context.typography.titleMedium,
                    color: context.colorPalette.neutral.grey9,
                  ),
                  const DSVerticalSpacerWidget(2),
                  _ViewStateBuilderWidget(state),
                ],
              ),
            ),
          );

          return isDialog
              ? content
              : Scaffold(
                  appBar: DSAppBarWidget(
                    height: DSAppBarWidget.getHeight(context),
                  ),
                  body: content,
                );
        },
      ),
    );
  }

  void _handleStateChanges(BuildContext context, LocaleSelectionState state) {
    switch (state) {
      case LocaleSelectionLoadErrorState():
      case LocaleSelectionUpdateErrorState():
        _showErrorSnackBar(context, state);
      default:
        break;
    }
  }

  void _showErrorSnackBar(BuildContext context, LocaleSelectionState state) {
    final String message = switch (state) {
      LocaleSelectionLoadErrorState() => state.failure.getMessage(context),
      LocaleSelectionUpdateErrorState() => state.failure.getMessage(context),
      _ => throw StateError('Unexpected state type for error handling'),
    };

    context.showSnackBar(
      snackBar: DSSnackBar(message: message, type: DSSnackBarType.error),
    );
  }
}

class _ViewStateBuilderWidget extends StatelessWidget {
  const _ViewStateBuilderWidget(this.state);

  final LocaleSelectionState state;

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      LocaleSelectionInitialState() ||
      LocaleSelectionLoadingState() => _buildLoadingWidget(context),

      final LocaleSelectionLoadedState state => _buildLocaleList(
        context: context,
        supportedLocales: state.supportedLocales,
        currentLocale: state.appLocale,
        isEnabled: true,
      ),

      final LocaleSelectionUpdatingState state => _buildLocaleList(
        context: context,
        supportedLocales: state.supportedLocales,
        currentLocale: state.currentLocale,
        targetLocale: state.targetLocale,
        isEnabled: false,
      ),

      final LocaleSelectionUpdateSuccessState state => _buildLocaleList(
        context: context,
        supportedLocales: state.supportedLocales,
        currentLocale: state.appLocale,
        isEnabled: true,
      ),

      final LocaleSelectionUpdateErrorState state => _buildLocaleList(
        context: context,
        supportedLocales: state.supportedLocales,
        currentLocale: state.appLocale,
        isEnabled: true,
      ),

      final LocaleSelectionLoadErrorState state => _buildErrorWidget(
        context,
        state.failure,
      ),

      // This should never happen, but ensures exhaustiveness
      LocaleSelectionState() => throw StateError(
        'Unexpected abstract state: ${state.runtimeType}',
      ),
    };
  }

  Widget _buildLoadingWidget(BuildContext context) {
    return Center(child: DSLoadingWidget(size: context.space(factor: 5)));
  }

  Widget _buildLocaleList({
    required BuildContext context,
    required List<Locale> supportedLocales,
    required AppLocale currentLocale,
    AppLocale? targetLocale,
    required bool isEnabled,
  }) {
    return _LocaleListWidget(
      supportedLocales: supportedLocales,
      currentLocale: currentLocale,
      targetLocale: targetLocale,
      isEnabled: isEnabled,
    );
  }

  Widget _buildErrorWidget(BuildContext context, GetLocaleFailure failure) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            size: context.space(factor: 8),
            color: context.colorPalette.semantic.error.color,
          ),
          const DSVerticalSpacerWidget(2),
          DSTextWidget(
            failure.getMessage(context),
            style: context.typography.bodyLarge,
            color: context.colorPalette.semantic.error,
            textAlign: TextAlign.center,
          ),
          const DSVerticalSpacerWidget(2),
          DSButtonWidget(
            label: context.localizations.retry,
            onPressed: () => context.read<LocaleSelectionBloc>().add(
              const LoadLocaleEvent(),
            ),
            variant: DSButtonVariant.secondary,
            size: DSButtonSize.small,
          ),
        ],
      ),
    );
  }
}

class _LocaleListWidget extends StatelessWidget {
  const _LocaleListWidget({
    required this.supportedLocales,
    required this.currentLocale,
    this.targetLocale,
    required this.isEnabled,
  });

  final List<Locale> supportedLocales;
  final AppLocale currentLocale;
  final AppLocale? targetLocale;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: supportedLocales
          .map((locale) => _buildLocaleOption(context, locale))
          .toList(),
    );
  }

  Widget _buildLocaleOption(BuildContext context, Locale locale) {
    final isTargeted = targetLocale != null && locale == targetLocale!.locale;

    return RadioListTile<Locale>(
      title: Row(
        children: [
          Expanded(
            child: DSTextWidget(
              locale.languageCode.languageName,
              style: context.typography.titleMedium,
              color: context.colorPalette.neutral.grey7,
            ),
          ),
          if (isTargeted) _buildLoadingIndicator(context),
        ],
      ),
      value: locale,
      groupValue: currentLocale.locale,
      onChanged: isEnabled
          ? (value) => _handleLocaleSelection(context, value)
          : null,
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const DSHorizontalSpacerWidget(1),
        SizedBox(
          width: context.space(factor: 2),
          height: context.space(factor: 2),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colorPalette.brand.primary.color,
          ),
        ),
      ],
    );
  }

  void _handleLocaleSelection(BuildContext context, Locale? value) {
    if (value != null) {
      context.read<LocaleSelectionBloc>().add(UpdateLocaleEvent(value));
    }
  }
}
