import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/advertiser_section_widget.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/item_data.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/widget/section_widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
              AdDetailItemData('Page name', ad.pageName),
              AdDetailItemData('Page ID', ad.pageId),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Creative',
            items: [
              AdDetailItemData('Body', ad.adCreativeBody),
              AdDetailItemData('Link title', ad.adCreativeLinkTitle),
              AdDetailItemData('Link description', ad.adCreativeLinkDescription),
              AdDetailItemData('Link caption', ad.adCreativeLinkCaption),
              AdDetailItemData('Destination URL', ad.adCreativeLinkUrl),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Delivery',
            items: [
              AdDetailItemData('Created', ad.adCreationTime),
              AdDetailItemData('Started', ad.adDeliveryStartTime),
              AdDetailItemData('Stopped', ad.adDeliveryStopTime),
              AdDetailItemData('Currency', ad.currency),
              AdDetailItemData('Funding entity', ad.fundingEntity),
              AdDetailItemData('Bylines', ad.bylines),
              AdDetailItemData(
                'Impressions',
                _rangeText(ad.impressionsLowerBound, ad.impressionsUpperBound),
              ),
              AdDetailItemData(
                'Spend',
                _rangeText(ad.spendLowerBound, ad.spendUpperBound),
              ),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Targeting',
            items: [
              AdDetailItemData('Platforms', ad.publisherPlatforms?.join(', ')),
              AdDetailItemData('Languages', ad.languages?.join(', ')),
              AdDetailItemData('Target gender', ad.targetGender),
              AdDetailItemData('Target ages', ad.targetAges?.join(', ')),
              AdDetailItemData('Target locations', ad.targetLocations?.join(', ')),
            ],
          ),
          AdDetailSectionWidget(
            title: 'Reach',
            items: [
              AdDetailItemData(
                'Est. audience size',
                _rangeText(
                  ad.estimatedAudienceSizeLowerBound,
                  ad.estimatedAudienceSizeUpperBound,
                ),
              ),
              AdDetailItemData(
                'EU total reach',
                ad.euTotalReach != null ? '~${ad.euTotalReach}' : null,
              ),
              AdDetailItemData(
                'Brazil total reach',
                ad.brTotalReach != null ? '~${ad.brTotalReach}' : null,
              ),
              AdDetailItemData(
                'Beneficiary / Payer',
                ad.beneficiaryPayers?.join(' • '),
              ),
            ],
          ),
          if (_hasDemographics(ad))
            AdDetailSectionWidget(
              title: 'Demographics',
              items: [
                if (ad.demographicDistribution != null)
                  AdDetailItemData(
                    'By age & gender',
                    _formatDistribution(
                      ad.demographicDistribution!,
                      ageKey: 'age',
                      genderKey: 'gender',
                      percentKey: 'percentage',
                    ),
                  ),
                if (ad.deliveryByRegion != null)
                  AdDetailItemData(
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
              AdDetailItemData('Ad Archive ID', ad.id),
              AdDetailItemData('Scraped at', ad.scrapedAt),
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
    return list.map((e) {
      final label = genderKey != null
          ? '${e[ageKey] ?? ''} ${e[genderKey] ?? ''}'.trim()
          : '${e[ageKey] ?? ''}'.trim();
      final pct = e[percentKey];
      final pctStr = pct is num ? '${pct.toStringAsFixed(1)}%' : '';
      return pctStr.isNotEmpty ? '$label: $pctStr' : label;
    }).join('\n');
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

