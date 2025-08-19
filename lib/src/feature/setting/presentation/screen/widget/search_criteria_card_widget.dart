import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/setting/presentation/screen/bloc/bloc.dart';

class SearchCriteriaCardWidget extends StatelessWidget {
  const SearchCriteriaCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingBloc, SettingState>(
      builder: (context, state) {
        final enabled =
            state is SettingLoadedState && state.locationBasedSearch;
        return DsCardWidget(
          backgroundColor: context.colorPalette.invertedBackground.primary,
          radius: context.dimen.radiusLevel2,
          elevation: context.dimen.elevationLevel1,
          margin: EdgeInsets.only(bottom: context.space(factor: 2)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: context.space(factor: 2),
                ),
                leading: Icon(
                  Icons.location_on,
                  size: context.iconSize,
                  color: context.colorPalette.neutral.grey1.color,
                ),
                title: DSTextWidget(
                  context.localizations.settingLocationBasedSearch,
                  color: context.colorPalette.neutral.grey1,
                  style: context.typography.titleMedium,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                ),
                trailing: Switch(
                  value: enabled,
                  onChanged: (val) {
                    context.read<SettingBloc>().add(
                      ToggleLocationBasedSearchEvent(val),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(factor: 2),
                ),
                child: DSTextWidget(
                  context.localizations.settingLocationBasedSearchDescription,
                  color: context.colorPalette.neutral.grey3,
                  style: context.typography.bodySmall,
                  maxLines: 5,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              const DSVerticalSpacerWidget(1),
            ],
          ),
        );
      },
    );
  }
}
