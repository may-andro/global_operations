import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';

final _radiusInKmOptions = [1, 2, 5, 10, 20];

class RadiusButtonWidget extends StatelessWidget {
  const RadiusButtonWidget({
    required this.selected,
    required this.onSelected,
    required this.isEnabled,
    super.key,
  });

  final int selected;
  final void Function(int) onSelected;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.radar_rounded,
        color: isEnabled
            ? context.colorPalette.background.onPrimary.color
            : context.colorPalette.background.disabled.color,
      ),
      onPressed: isEnabled
          ? () async {
              final option = await _OptionsWidget.showAsDialogOrBottomSheet(
                context,
                selected,
              );
              if (option case final int option) {
                onSelected(option);
              }
            }
          : null,
    );
  }
}

class _OptionsWidget extends StatelessWidget {
  const _OptionsWidget(this.selected);

  final int? selected;

  static Future<int?> _showAsBottomSheet(BuildContext context, int selected) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          DSBottomSheetWidget(child: _OptionsWidget(selected)),
    );
  }

  static Future<int?> _showAsDialog(BuildContext context, int selected) {
    return showDialog<int>(
      context: context,
      builder: (context) {
        return DSDialogWidget(child: _OptionsWidget(selected));
      },
    );
  }

  static Future<int?> showAsDialogOrBottomSheet(
    BuildContext context,
    int selected,
  ) {
    if (context.isDesktop) {
      return _showAsDialog(context, selected);
    }

    return _showAsBottomSheet(context, selected);
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
              context.localizations.adPanelSearchRadiusTitle,
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            const DSVerticalSpacerWidget(2),
            ..._radiusInKmOptions.map((radius) {
              return _ItemWidget(
                isSelected: selected == radius,
                radius: radius,
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({required this.isSelected, required this.radius});

  final bool isSelected;
  final int radius;

  @override
  Widget build(BuildContext context) {
    final colorSelected = context.colorPalette.brand.primary;
    final colorUnselected = context.colorPalette.background.onPrimary;
    final color = isSelected ? colorSelected : colorUnselected;
    return ListTile(
      leading: DSCircularIconCardWidget(
        icon: Icons.radar_rounded,
        color: isSelected
            ? context.colorPalette.brand.onPrimary
            : context.colorPalette.invertedBackground.onPrimary,
        backgroundColor: isSelected
            ? colorSelected
            : context.colorPalette.invertedBackground.primary,
      ),
      title: DSTextWidget(
        context.localizations.adPanelSearchRadiusLabel(radius.toString()),
        style: context.typography.titleMedium,
        color: color,
      ),
      subtitle: DSTextWidget(
        radius > defaultSearchRadius
            ? context.localizations.adPanelSearchRadiusNoLocationUpdateDescription
            : context
                  .localizations
                  .adPanelSearchRadiusLocationUpdateDescription,
        style: context.typography.labelSmall,
        color: color,
      ),
      onTap: () => Navigator.pop(context, radius),
    );
  }
}
