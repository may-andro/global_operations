import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';

class SortButtonWidget extends StatelessWidget {
  const SortButtonWidget({
    required this.sortOptions,
    required this.selected,
    required this.onSelected,
    required this.isVisible,
    this.isEnabled = true,
    super.key,
  });

  final List<AdPanelSortOption> sortOptions;
  final AdPanelSortOption selected;
  final void Function(AdPanelSortOption) onSelected;
  final bool isVisible;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: 300.milliseconds,
      switchInCurve: Curves.easeIn,
      switchOutCurve: Curves.easeOut,
      child: isVisible
          ? IconButton(
              icon: Icon(
                Icons.sort,
                color: isEnabled
                    ? context.colorPalette.background.onPrimary.color
                    : context.colorPalette.background.disabled.color,
              ),
              tooltip: context.localizations.adPanelSortTooltip,
              onPressed: isEnabled
                  ? () async {
                      final option =
                          await _OptionsWidget.showAsDialogOrBottomSheet(
                            context,
                            selected,
                            sortOptions,
                          );
                      if (option case final AdPanelSortOption option) {
                        onSelected(option);
                      }
                    }
                  : null,
            )
          : const SizedBox.shrink(key: ValueKey('not_loading')),
    );
  }
}

class _OptionsWidget extends StatelessWidget {
  const _OptionsWidget({required this.sortOptions, this.selected});

  final AdPanelSortOption? selected;
  final List<AdPanelSortOption> sortOptions;

  static Future<AdPanelSortOption?> _showAsBottomSheet(
    BuildContext context,
    AdPanelSortOption selected,
    List<AdPanelSortOption> sortOptions,
  ) {
    return showModalBottomSheet<AdPanelSortOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DSBottomSheetWidget(
        child: _OptionsWidget(selected: selected, sortOptions: sortOptions),
      ),
    );
  }

  static Future<AdPanelSortOption?> _showAsDialog(
    BuildContext context,
    AdPanelSortOption selected,
    List<AdPanelSortOption> sortOptions,
  ) {
    return showDialog<AdPanelSortOption>(
      context: context,
      builder: (context) {
        return DSDialogWidget(
          child: _OptionsWidget(selected: selected, sortOptions: sortOptions),
        );
      },
    );
  }

  static Future<AdPanelSortOption?> showAsDialogOrBottomSheet(
    BuildContext context,
    AdPanelSortOption selected,
    List<AdPanelSortOption> sortOptions,
  ) {
    if (context.isDesktop) {
      return _showAsDialog(context, selected, sortOptions);
    }

    return _showAsBottomSheet(context, selected, sortOptions);
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
              context.localizations.adPanelSortingOptions,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            ...sortOptions.map((sortOption) {
              return _ItemWidget(
                isSelected: selected == sortOption,
                sortOption: sortOption,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({required this.isSelected, required this.sortOption});

  final bool isSelected;
  final AdPanelSortOption sortOption;

  @override
  Widget build(BuildContext context) {
    final colorSelected = context.colorPalette.brand.primary;
    final colorUnselected = context.colorPalette.background.onPrimary;
    final color = isSelected ? colorSelected : colorUnselected;
    return ListTile(
      leading: DSCircularIconCardWidget(
        icon: sortOption.icon,
        color: isSelected
            ? context.colorPalette.brand.onPrimary
            : context.colorPalette.invertedBackground.onPrimary,
        backgroundColor: isSelected
            ? colorSelected
            : context.colorPalette.invertedBackground.primary,
      ),
      title: DSTextWidget(
        sortOption.displayName(context),
        style: context.typography.titleMedium,
        color: color,
      ),
      subtitle: DSTextWidget(
        sortOption.displayDescription(context),
        style: context.typography.labelSmall,
        color: color,
      ),
      onTap: () => Navigator.pop(context, sortOption),
    );
  }
}
