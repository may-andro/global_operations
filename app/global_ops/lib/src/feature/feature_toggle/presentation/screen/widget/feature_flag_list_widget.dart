import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/widget/empty_content_widget.dart';

class FeatureFlagsListWidget extends StatelessWidget {
  const FeatureFlagsListWidget({
    super.key,
    required this.featureFlags,
    this.isGridVisible = false,
    this.searchQuery = '',
  });

  final List<FeatureFlag> featureFlags;
  final bool isGridVisible;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {
    if (featureFlags.isEmpty) {
      return EmptyContentWidget(searchQuery: searchQuery);
    }

    if (isGridVisible) {
      return _GridWidget(
        featureFlags: featureFlags,
        onClicked: (featureFlag) {
          context.bloc.add(UpdateFFEvent(featureFlag: featureFlag));
        },
      );
    } else {
      return _ListWidget(
        featureFlags: featureFlags,
        onClicked: (featureFlag) {
          context.bloc.add(UpdateFFEvent(featureFlag: featureFlag));
        },
      );
    }
  }
}

class _ListWidget extends StatelessWidget {
  const _ListWidget({required this.featureFlags, required this.onClicked});

  final List<FeatureFlag> featureFlags;
  final void Function(FeatureFlag) onClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.space(factor: 2)),
      child: ListView.separated(
        itemCount: featureFlags.length + 1,
        shrinkWrap: true,
        separatorBuilder: (_, index) =>
            DSVerticalSpacerWidget(index == 0 ? 0 : 1),
        itemBuilder: (context, index) {
          if (index == 0) {
            return const DSVerticalSpacerWidget(1);
          }
          final featureFlag = featureFlags[index - 1];
          return DsCardWidget(
            backgroundColor: featureFlag.isEnabled
                ? context.colorPalette.brand.primary
                : context.colorPalette.neutral.grey3,
            radius: context.dimen.radiusLevel2,
            elevation: context.dimen.elevationLevel1,
            child: SwitchListTile.adaptive(
              title: DSTextWidget(
                featureFlag.feature.title,
                color: featureFlag.isEnabled
                    ? context.colorPalette.brand.onPrimary
                    : context.colorPalette.neutral.grey7,
                style: context.typography.bodyMedium,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
              subtitle: DSTextWidget(
                featureFlag.feature.key,
                color: featureFlag.isEnabled
                    ? context.colorPalette.brand.onPrimary
                    : context.colorPalette.neutral.grey7,
                style: context.typography.bodySmall,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
              secondary: Icon(
                featureFlag.feature.icon,
                color: featureFlag.isEnabled
                    ? context.colorPalette.brand.onPrimary.color
                    : context.colorPalette.neutral.grey7.color,
              ),
              activeColor: context.colorPalette.brand.primary.color,
              activeTrackColor: context.colorPalette.brand.onPrimary.color,
              inactiveThumbColor: context.colorPalette.neutral.grey7.color,
              inactiveTrackColor: context.colorPalette.neutral.grey3.color,
              value: featureFlag.isEnabled,
              onChanged: (value) {
                onClicked(
                  FeatureFlag(featureFlag.feature, !featureFlag.isEnabled),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _GridWidget extends StatelessWidget {
  const _GridWidget({required this.featureFlags, required this.onClicked});

  final List<FeatureFlag> featureFlags;
  final void Function(FeatureFlag) onClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.space(factor: 2)),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: context.crossAxisCount,
        crossAxisSpacing: context.space(factor: 0.5),
        mainAxisSpacing: context.space(factor: 0.5),
        children: featureFlags.map((featureFlag) {
          return _GridItemWidget(
            featureFlag: featureFlag,
            onClicked: onClicked,
          );
        }).toList(),
      ),
    );
  }
}

class _GridItemWidget extends StatelessWidget {
  const _GridItemWidget({required this.featureFlag, required this.onClicked});

  final FeatureFlag featureFlag;
  final void Function(FeatureFlag) onClicked;

  @override
  Widget build(BuildContext context) {
    return DsCardWidget(
      backgroundColor: featureFlag.isEnabled
          ? context.colorPalette.brand.primary
          : context.colorPalette.neutral.grey3,
      radius: context.dimen.radiusLevel2,
      elevation: context.dimen.elevationLevel1,
      margin: EdgeInsets.only(top: context.space()),
      onTap: () {
        onClicked(FeatureFlag(featureFlag.feature, !featureFlag.isEnabled));
      },
      child: Padding(
        padding: EdgeInsets.all(context.space()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              featureFlag.feature.icon,
              color: featureFlag.isEnabled
                  ? context.colorPalette.brand.onPrimary.color
                  : context.colorPalette.neutral.grey7.color,
            ),
            const DSVerticalSpacerWidget(1),
            Flexible(
              child: DSTextWidget(
                featureFlag.feature.title,
                textAlign: TextAlign.center,
                color: featureFlag.isEnabled
                    ? context.colorPalette.brand.onPrimary
                    : context.colorPalette.neutral.grey7,
                style: context.typography.bodyMedium,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension on BuildContext {
  int get crossAxisCount {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return 3;
      case DSDeviceWidthResolution.s:
        return 4;
      case DSDeviceWidthResolution.m:
        return 5;
      case DSDeviceWidthResolution.l:
        return 6;
      case DSDeviceWidthResolution.xl:
        return 8;
    }
  }
}
