import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/extension/platform_extension.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/advertiser_section_widget.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/item_data.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return;
  final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
  if (!launched) {
    await launchUrl(uri);
  }
}

class AdDetailViewWidget extends StatelessWidget {
  const AdDetailViewWidget({super.key, required this.ad});

  final FbAdEntity ad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorPalette.background.primary.color,
      appBar: AppBar(
        backgroundColor: context.colorPalette.background.primary.color,
        surfaceTintColor: context.colorPalette.neutral.transparent.color,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: DSTextWidget(
          ad.pageName ?? ad.id,
          style: context.typography.titleMedium,
          color: context.colorPalette.neutral.grey9,
          maxLines: 1,
          textOverflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (ad.adSnapshotUrl != null)
            IconButton(
              icon: DSIconWidget(
                Icons.open_in_browser,
                size: DSIconSize.medium,
                color: context.colorPalette.brand.primary,
              ),
              tooltip: 'Open snapshot',
              onPressed: () => _launchUrl(ad.adSnapshotUrl!),
            ),
          const DSHorizontalSpacerWidget(1),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(context.space(factor: 2)),
        children: [
          AdDetailSectionWidget(
            title: 'Page',
            items: [
              AdDetailChipItem('Page name', [ad.pageName]),
              AdDetailChipItem('Page ID', [ad.pageId]),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Creative',
            items: [
              AdDetailListItem('Body', ad.adCreativeBodies ?? []),
              AdDetailListItem('Link title', ad.adCreativeLinkTitles ?? []),
              AdDetailListItem(
                'Link description',
                ad.adCreativeLinkDescriptions ?? [],
              ),
              AdDetailHyperlinkItem(
                'Link caption',
                ad.adCreativeLinkCaptions ?? [],
              ),
              AdDetailHyperlinkItem(
                'Destination URL',
                ad.adCreativeLinkUrls ?? [],
              ),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Delivery',
            items: [
              AdDetailDateItem('Created', ad.adCreationTime),
              AdDetailDateItem('Started', ad.adDeliveryStartTime),
              AdDetailDateItem('Stopped', ad.adDeliveryStopTime),
              AdDetailTextItem('Currency', ad.currency),
              AdDetailTextItem('Funding entity', ad.fundingEntity),
              AdDetailTextItem('Bylines', ad.bylines),
              AdDetailChipItem('Impressions', [
                _rangeText(ad.impressionsLowerBound, ad.impressionsUpperBound),
              ]),
              AdDetailChipItem('Spend', [
                _rangeText(ad.spendLowerBound, ad.spendUpperBound),
              ]),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Targeting',
            items: [
              AdDetailIconItem(
                'Platforms',
                ad.publisherPlatforms
                        ?.map((platform) => platform.platformIcon)
                        .toList() ??
                    [],
              ),
              AdDetailTextItem('Languages', ad.languages?.join(', ')),
              AdDetailTextItem('Target gender', ad.targetGender),
              AdDetailTextItem('Target ages', ad.targetAges?.join(', ')),
              AdDetailTextItem(
                'Target locations',
                ad.targetLocations?.join(', '),
              ),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Reach',
            items: [
              AdDetailTextItem(
                'Est. audience size',
                _rangeText(
                  ad.estimatedAudienceSizeLowerBound,
                  ad.estimatedAudienceSizeUpperBound,
                ),
              ),
              AdDetailChipItem('EU total reach', [
                if (ad.euTotalReach != null) '~${ad.euTotalReach}' else null,
              ]),
              AdDetailChipItem('Brazil total reach', [
                if (ad.brTotalReach != null) '~${ad.brTotalReach}' else null,
              ]),
              AdDetailChipItem(
                'Beneficiary / Payer',
                ad.beneficiaryPayers ?? [],
              ),
            ],
          ),
          if (_hasDemographics(ad))
            AdDetailSectionWidget(
              title: 'Demographics',
              items: [
                if (ad.demographicDistribution != null)
                  AdDetailTextItem(
                    'By age & gender',
                    _formatDistribution(
                      ad.demographicDistribution!,
                      ageKey: 'age',
                      genderKey: 'gender',
                      percentKey: 'percentage',
                    ),
                  ),
                if (ad.deliveryByRegion != null)
                  AdDetailTextItem(
                    'By region',
                    _formatDistribution(
                      ad.deliveryByRegion!,
                      ageKey: 'region',
                      genderKey: null,
                      percentKey: 'percentage',
                    ),
                  ),
              ],
            ),
          AdDetailSectionWidget(
            title: 'Meta',
            items: [
              AdDetailChipItem('Ad Archive ID', [ad.id]),
              AdDetailDateItem('Scraped at', ad.scrapedAt),
              AdDetailTextItem('Total Ads Found', ad.totalAdsFound?.toString()),
            ],
          ),
          AdvertiserSectionWidget(ad: ad),
          if (ad.adSnapshotUrl != null) ...[
            DSVerticalSpacerWidget(context.space(factor: 2) / context.space()),
            DSButtonWidget(
              label: 'View Ad Snapshot',
              icon: Icons.open_in_browser,
              onPressed: () => _launchUrl(ad.adSnapshotUrl!),
            ),
            DSVerticalSpacerWidget(context.space(factor: 2) / context.space()),
          ],
        ],
      ),
    );
  }

  String? _rangeText(int? lower, int? upper) {
    if (lower == null && upper == null) return null;
    return '${lower ?? '?'} – ${upper ?? '?'}';
  }

  bool _hasDemographics(FbAdEntity ad) =>
      (ad.demographicDistribution?.isNotEmpty ?? false) ||
      (ad.deliveryByRegion?.isNotEmpty ?? false);

  String? _formatDistribution(
    List<Map<String, dynamic>> list, {
    required String ageKey,
    required String? genderKey,
    required String percentKey,
  }) {
    if (list.isEmpty) return null;
    return list
        .map((e) {
          final label = genderKey != null
              ? '${e[ageKey] ?? ''} ${e[genderKey] ?? ''}'.trim()
              : '${e[ageKey] ?? ''}'.trim();
          final pct = e[percentKey];
          final pctStr = pct is num ? '${pct.toStringAsFixed(1)}%' : '';
          return pctStr.isNotEmpty ? '$label: $pctStr' : label;
        })
        .join('\n');
  }
}
