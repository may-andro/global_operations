import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/fb_ad_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/ads_detail_screen.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/widget/delivery_badge_widget.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/widget/platforms_widget.dart';
import 'package:flutter/material.dart';

class AdCardWidget extends StatelessWidget {
  const AdCardWidget({super.key, required this.ad});

  final FbAdEntity ad;

  @override
  Widget build(BuildContext context) {
    final isActive =
        ad.adDeliveryStopTime == null || ad.adDeliveryStopTime!.isEmpty;
    final adCreativeBodies = ad.adCreativeBodies;
    final publisherPlatforms = ad.publisherPlatforms;
    final targetGender = ad.targetGender;
    final targetAges = ad.targetAges;

    return DsCardWidget(
      backgroundColor: context.colorPalette.invertedBackground.primary,
      radius: context.dimen.radiusLevel2,
      elevation: context.dimen.elevationLevel1,
      margin: EdgeInsets.only(bottom: context.space()),
      onTap: () => AdDetailScreen.navigate(context, ad: ad),
      child: Padding(
        padding: EdgeInsets.all(
          context.space(factor: context.isMobile ? 2 : 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: context.space(factor: 0.5),
          children: [
            // ── Title row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: context.space(),
              children: [
                Expanded(
                  child: DSTextWidget(
                    ad.pageName ?? ad.pageId ?? 'Unknown page',
                    color: context.colorPalette.neutral.grey1,
                    style: context.typography.titleMedium,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                DeliveryBadgeWidget(isActive: isActive),
              ],
            ),
            DSHorizontalDividerWidget(
              thickness: 1,
              color: context.colorPalette.neutral.grey6,
            ),
            // ── Ad body ──
            if (adCreativeBodies != null && adCreativeBodies.isNotEmpty)
              DSTextWidget(
                adCreativeBodies.first,
                color: context.colorPalette.neutral.grey2,
                style: context.typography.bodyMedium,
                maxLines: 2,
                textOverflow: TextOverflow.ellipsis,
              ),
            // ── Platforms ──
            if (publisherPlatforms != null && publisherPlatforms.isNotEmpty)
              PlatformsWidget(platforms: publisherPlatforms),

            // ── Target gender / ages ──
            if (targetGender != null || targetAges != null) ...[
              _InfoRowWidget(
                icon: targetGender.genderIcon,
                label: _targetLabel(ad),
              ),
            ],

            // ── Impressions ──
            if (ad.impressionsLowerBound != null ||
                ad.impressionsUpperBound != null)
              _InfoRowWidget(
                icon: Icons.visibility_outlined,
                label: _rangeLabel(
                  ad.impressionsLowerBound,
                  ad.impressionsUpperBound,
                  suffix: ' impressions',
                ),
              ),

            // ── Spend ──
            if (ad.spendLowerBound != null || ad.spendUpperBound != null)
              _InfoRowWidget(
                icon: Icons.attach_money_rounded,
                label: _rangeLabel(
                  ad.spendLowerBound,
                  ad.spendUpperBound,
                  prefix: ad.currency != null ? '${ad.currency} ' : '',
                ),
              ),

            // ── Reach (EU / BR) ──
            if (ad.euTotalReach != null || ad.brTotalReach != null)
              _InfoRowWidget(
                icon: Icons.public_rounded,
                label: _reachLabel(ad),
              ),

            // ── Creation date ──
            if (ad.adCreationTime != null)
              _InfoRowWidget(
                icon: Icons.calendar_today_outlined,
                label:
                    ad.adCreationTime?.toFormattedDate.toFullDateWithoutTime ??
                    'Unknown date',
              ),
          ],
        ),
      ),
    );
  }

  String _targetLabel(FbAdEntity ad) {
    final parts = <String>[];
    if (ad.targetAges != null && ad.targetAges!.isNotEmpty) {
      parts.add(ad.targetAges!.join(' - '));
      parts.add('Age Groups');
    }
    return parts.join(' ');
  }

  String _rangeLabel(
    int? lower,
    int? upper, {
    String prefix = '',
    String suffix = '',
  }) {
    if (lower == null && upper == null) return '';
    return '$prefix${lower ?? '?'} – ${upper ?? '?'}$suffix';
  }

  String _reachLabel(FbAdEntity ad) {
    final parts = <String>[];
    if (ad.euTotalReach != null) parts.add('EU ~${ad.euTotalReach}');
    if (ad.brTotalReach != null) parts.add('BR ~${ad.brTotalReach}');
    return parts.join(' · ');
  }
}

class _InfoRowWidget extends StatelessWidget {
  const _InfoRowWidget({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DSIconWidget(
          icon,
          size: DSIconSize.small,
          color: context.colorPalette.neutral.grey3,
        ),
        const DSHorizontalSpacerWidget(0.5),
        Flexible(
          child: DSTextWidget(
            label,
            color: context.colorPalette.neutral.grey3,
            style: context.typography.bodyMedium,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

extension on String? {
  IconData get genderIcon => switch (this?.toLowerCase()) {
    'male' => Icons.male_rounded,
    'men' => Icons.male_rounded,
    'women' => Icons.female_rounded,
    'female' => Icons.female_rounded,
    'all' => Icons.people_outline_rounded,
    _ => Icons.help_outline_rounded,
  };
}
