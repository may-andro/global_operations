import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/extension/platform_extension.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/item_data.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/row_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdvertiserSectionWidget extends StatelessWidget {
  const AdvertiserSectionWidget({super.key, required this.ad});

  final FbAdEntity ad;

  String? get _pageUrl =>
      ad.pageId != null ? 'https://www.facebook.com/${ad.pageId}' : null;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdDetailBloc, AdDetailState>(
      builder: (context, state) {
        final info = state.pageInfo;
        final isLoading = state.status == AdDetailPageInfoStatus.loading;

        final items = <AdDetailItemData>[
          AdDetailChipItem('Page name', [info?.name ?? ad.pageName]),
          AdDetailChipItem('Category', [info?.category]),
          AdDetailTextItem('About', info?.about ?? info?.description),
          AdDetailTextItem('Phone', info?.phone),
          AdDetailTextItem('Email', info?.emails?.join(', ')),
          AdDetailHyperlinkItem('Website', [
            info?.website ?? ad.adCreativeLinkUrls?.join(', '),
          ]),
          AdDetailHyperlinkItem('Facebook page', [info?.link ?? _pageUrl]),
          AdDetailTextItem('Address', info?.fullAddress),
          AdDetailTextItem(
            'Page likes',
            info?.fanCount != null ? _formatCount(info!.fanCount!) : null,
          ),
          AdDetailTextItem('Founded', info?.founded),
          AdDetailTextItem('Verification', switch (info?.verificationStatus) {
            'blue_verified' => '✓ Blue verified',
            'gray_verified' => '✓ Gray verified',
            _ => null,
          }),
          AdDetailTextItem('Declared funder', ad.bylines ?? ad.fundingEntity),
          AdDetailTextItem('Currency', ad.currency),
          AdDetailIconItem(
            'Platforms',
            ad.publisherPlatforms
                    ?.map((platform) => platform.platformIcon)
                    .toList() ??
                [],
          ),
          AdDetailTextItem('Languages', ad.languages?.join(', ')),
        ].where((i) => i.isRelevant).toList();

        if (items.isEmpty && !isLoading) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DSVerticalSpacerWidget(
              context.space(factor: 1.5) / context.space(),
            ),
            Row(
              children: [
                DSTextWidget(
                  'Advertiser',
                  style: context.typography.titleSmall,
                  color: context.colorPalette.neutral.grey9,
                ),
                if (isLoading) ...[
                  SizedBox(width: context.space()),
                  DSLoadingWidget(size: context.space(factor: 2)),
                ],
              ],
            ),
            DSVerticalSpacerWidget(
              context.space(factor: 0.75) / context.space(),
            ),
            if (items.isNotEmpty)
              DsCardWidget(
                backgroundColor:
                    context.colorPalette.invertedBackground.primary,
                radius: context.dimen.radiusLevel2,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.space(factor: 2),
                    vertical: context.space(),
                  ),
                  child: Column(
                    children: [
                      for (int i = 0; i < items.length; i++) ...[
                        AdDetailRowWidget(item: items[i]),
                        if (i < items.length - 1)
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
      },
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
