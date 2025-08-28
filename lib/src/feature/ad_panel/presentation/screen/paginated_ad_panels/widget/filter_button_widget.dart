import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';

const List<AdPanelFilterOption> _filterOptions = [
  ObjectNumberFilterOption(),
  StreetFilterOption(),
  MunicipalityFilterOption(),
];

class FilterButtonWidget extends StatelessWidget {
  const FilterButtonWidget({
    required this.selected,
    required this.onSelected,
    required this.isVisible,
    this.isEnabled = true,
    super.key,
  });

  final AdPanelFilterOption selected;
  final void Function(AdPanelFilterOption) onSelected;
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
                Icons.filter_alt_rounded,
                color: isEnabled
                    ? context.colorPalette.background.onPrimary.color
                    : context.colorPalette.neutral.grey5.color,
              ),
              onPressed: isEnabled
                  ? () async {
                      final option =
                          await _OptionsWidget.showAsDialogOrBottomSheet(
                            context,
                            selected,
                            _filterOptions,
                          );
                      if (option case final AdPanelFilterOption option) {
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
  const _OptionsWidget({required this.filterOptions, this.selected});

  final AdPanelFilterOption? selected;
  final List<AdPanelFilterOption> filterOptions;

  static Future<AdPanelFilterOption?> _showAsBottomSheet(
    BuildContext context,
    AdPanelFilterOption selected,
    List<AdPanelFilterOption> filterOptions,
  ) {
    return showModalBottomSheet<AdPanelFilterOption>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DSBottomSheetWidget(
        child: _OptionsWidget(selected: selected, filterOptions: filterOptions),
      ),
    );
  }

  static Future<AdPanelFilterOption?> _showAsDialog(
    BuildContext context,
    AdPanelFilterOption selected,
    List<AdPanelFilterOption> filterOptions,
  ) {
    return showDialog<AdPanelFilterOption>(
      context: context,
      builder: (context) {
        return DSDialogWidget(
          child: _OptionsWidget(
            selected: selected,
            filterOptions: filterOptions,
          ),
        );
      },
    );
  }

  static Future<AdPanelFilterOption?> showAsDialogOrBottomSheet(
    BuildContext context,
    AdPanelFilterOption selected,
    List<AdPanelFilterOption> filterOptions,
  ) {
    if (context.isDesktop) {
      return _showAsDialog(context, selected, filterOptions);
    }

    return _showAsBottomSheet(context, selected, filterOptions);
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
              context.localizations.adPanelSearchFilterTitle,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            ...filterOptions.map((filterOption) {
              return _ItemWidget(
                isSelected: selected == filterOption,
                filterOption: filterOption,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({required this.isSelected, required this.filterOption});

  final bool isSelected;
  final AdPanelFilterOption filterOption;

  @override
  Widget build(BuildContext context) {
    final colorSelected = context.colorPalette.brand.primary;
    final colorUnselected = context.colorPalette.background.onPrimary;
    final color = isSelected ? colorSelected : colorUnselected;
    return ListTile(
      leading: DSCircularIconCardWidget(
        icon: filterOption.icon,
        color: isSelected
            ? context.colorPalette.brand.onPrimary
            : context.colorPalette.invertedBackground.onPrimary,
        backgroundColor: isSelected
            ? colorSelected
            : context.colorPalette.invertedBackground.primary,
      ),
      title: DSTextWidget(
        filterOption.displayName(context),
        style: context.typography.titleMedium,
        color: color,
      ),
      subtitle: DSTextWidget(
        filterOption.displayDescription(context),
        style: context.typography.labelSmall,
        color: color,
      ),
      onTap: () => Navigator.pop(context, filterOption),
    );
  }
}
