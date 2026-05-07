import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/item_data.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/row_widget.dart';
import 'package:flutter/material.dart';

class AdDetailSectionWidget extends StatelessWidget {
  const AdDetailSectionWidget({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<AdDetailItemData> items;

  @override
  Widget build(BuildContext context) {
    final relevant = items.where((i) => i.value != null).toList();
    if (relevant.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSVerticalSpacerWidget(context.space(factor: 1.5) / context.space()),
        DSTextWidget(
          title,
          style: context.typography.titleSmall,
          color: context.colorPalette.neutral.grey9,
        ),
        DSVerticalSpacerWidget(context.space(factor: 0.75) / context.space()),
        DsCardWidget(
          backgroundColor: context.colorPalette.invertedBackground.primary,
          radius: context.dimen.radiusLevel2,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.space(factor: 2),
              vertical: context.space(),
            ),
            child: Column(
              children: [
                for (int i = 0; i < relevant.length; i++) ...[
                  AdDetailRowWidget(item: relevant[i]),
                  if (i < relevant.length - 1)
                    DSHorizontalDividerWidget(
                      thickness: 1,
                      color: context.colorPalette.background.onPrimary,
                    ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
