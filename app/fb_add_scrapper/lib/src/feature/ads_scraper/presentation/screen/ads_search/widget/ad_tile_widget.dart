import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/ads_detail_screen.dart';
import 'package:flutter/material.dart';

class AdTileWidget extends StatelessWidget {
  const AdTileWidget({super.key, required this.ad, this.trailing});

  final FbAdEntity ad;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return DsCardWidget(
      radius: context.dimen.radiusLevel2,
      elevation: context.dimen.elevationLevel1,
      margin: EdgeInsets.only(bottom: context.space()),
      onTap: () => AdDetailScreen.navigate(context, ad: ad),
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: context.isMobile ? 2 : 1)),
        child: Row(
          children: [
            DsCardWidget(
              radius: context.dimen.radiusLevel2,
              backgroundColor: context.colorPalette.brand.primary,
              child: Padding(
                padding: EdgeInsets.all(context.space()),
                child: DSIconWidget(
                  Icons.campaign_outlined,
                  color: context.colorPalette.brand.onPrimary,
                  size: DSIconSize.medium,
                ),
              ),
            ),
            SizedBox(width: context.space(factor: 1.5)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DSTextWidget(
                    ad.pageName ?? ad.pageId ?? ad.id,
                    style: context.typography.titleSmall,
                    color: context.colorPalette.neutral.grey9,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  if (ad.adCreativeBody != null ||
                      ad.adCreativeLinkTitle != null) ...[
                    SizedBox(height: context.space(factor: 0.5)),
                    DSTextWidget(
                      ad.adCreativeBody ?? ad.adCreativeLinkTitle ?? '',
                      style: context.typography.bodySmall,
                      color: context.colorPalette.neutral.grey5,
                      maxLines: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (ad.adDeliveryStartTime != null) ...[
                    SizedBox(height: context.space(factor: 0.5)),
                    Row(
                      children: [
                        DSIconWidget(
                          Icons.calendar_today_outlined,
                          size: DSIconSize.small,
                          color: context.colorPalette.neutral.grey4,
                        ),
                        const DSHorizontalSpacerWidget(0.5),
                        DSTextWidget(
                          ad.adDeliveryStartTime!,
                          style: context.typography.bodySmall,
                          color: context.colorPalette.neutral.grey4,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else
              DSIconWidget(
                Icons.arrow_forward_ios,
                size: DSIconSize.small,
                color: context.colorPalette.neutral.grey4,
              ),
          ],
        ),
      ),
    );
  }
}

