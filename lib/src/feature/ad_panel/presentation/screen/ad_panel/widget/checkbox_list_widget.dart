import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/entity/ad_panel_entity.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panel/bloc/bloc.dart';

class CheckboxListWidget extends StatelessWidget {
  const CheckboxListWidget({
    super.key,
    required this.adPanel,
    required this.index,
  });

  final AdPanelEntity adPanel;
  final int index;

  @override
  Widget build(BuildContext context) {
    final checkboxes = [
      _CheckboxConfig(
        label: context.localizations.adPanelCheckboxObjectCampaignIssue,
        value: adPanel.objectCampaignIssue,
        onChanged: (val) => _updatePanel(
          context,
          adPanel.copyWith(objectCampaignIssue: val),
          index,
        ),
      ),
      _CheckboxConfig(
        label: context.localizations.adPanelCheckboxObjectAdvertisementIssue,
        value: adPanel.objectAdvertisementIssue,
        onChanged: (val) => _updatePanel(
          context,
          adPanel.copyWith(objectAdvertisementIssue: val),
          index,
        ),
      ),
      _CheckboxConfig(
        label: context.localizations.adPanelCheckboxObjectDamageIssue,
        value: adPanel.objectDamageIssue,
        onChanged: (val) => _updatePanel(
          context,
          adPanel.copyWith(objectDamageIssue: val),
          index,
        ),
      ),
      _CheckboxConfig(
        label: context.localizations.adPanelCheckboxObjectCleanIssue,
        value: adPanel.objectCleanIssue,
        onChanged: (val) => _updatePanel(
          context,
          adPanel.copyWith(objectCleanIssue: val),
          index,
        ),
      ),
      _CheckboxConfig(
        label: context.localizations.adPanelCheckboxObjectPosterIssue,
        value: adPanel.objectPosterIssue,
        onChanged: (val) => _updatePanel(
          context,
          adPanel.copyWith(objectPosterIssue: val),
          index,
        ),
      ),
      _CheckboxConfig(
        label: context.localizations.adPanelCheckboxObjectLighteningIssue,
        value: adPanel.objectLighteningIssue,
        onChanged: (val) => _updatePanel(
          context,
          adPanel.copyWith(objectLighteningIssue: val),
          index,
        ),
      ),
      _CheckboxConfig(
        label: context.localizations.adPanelCheckboxObjectMaintenanceIssue,
        value: adPanel.objectMaintenanceIssue,
        onChanged: (val) => _updatePanel(
          context,
          adPanel.copyWith(objectMaintenanceIssue: val),
          index,
        ),
      ),
    ];

    return Column(
      children: [
        for (final c in checkboxes)
          CheckboxListTile(
            value: c.value,
            onChanged: (val) => c.onChanged(val ?? false),
            title: DSTextWidget(
              c.label,
              style: context.typography.bodyMedium,
              color: context.colorPalette.background.onPrimary,
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
      ],
    );
  }

  void _updatePanel(BuildContext context, AdPanelEntity updated, int index) {
    context.read<AdPanelBloc>().add(EditAdPanelEvent(index, updated));
  }
}

class _CheckboxConfig {
  _CheckboxConfig({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
}
