import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/item_data.dart';
import 'package:flutter/material.dart';

class AdDetailRowWidget extends StatelessWidget {
  const AdDetailRowWidget({super.key, required this.item});

  final AdDetailItemData item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.space(factor: 0.75)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: context.space(factor: 14),
            child: DSTextWidget(
              item.label,
              style: context.typography.bodySmall,
              color: context.colorPalette.neutral.grey5,
            ),
          ),
          SizedBox(width: context.space()),
          Expanded(
            child: SelectableText(
              item.value!,
              style: context.typography.bodySmall.textStyle.copyWith(
                color: context.colorPalette.invertedBackground.onPrimary.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
