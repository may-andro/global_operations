import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/fb_ad_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/ads_detail_screen.dart';
import 'package:flutter/material.dart';

class AdCardWidget extends StatelessWidget {
  const AdCardWidget({super.key, required this.ad});

  final FbAdEntity ad;

  @override
  Widget build(BuildContext context) {
    final isActive =
        ad.adDeliveryStopTime == null || ad.adDeliveryStopTime!.isEmpty;

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
          children: [
            // ── Title row ──
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                const SizedBox(width: 8),
                _DeliveryBadgeWidget(isActive: isActive),
              ],
            ),
            SizedBox(height: context.space(factor: 0.5)),

            // ── Ad body ──
            if (ad.adCreativeBody != null && ad.adCreativeBody!.isNotEmpty)
              _InfoRowWidget(
                icon: Icons.notes_rounded,
                label: ad.adCreativeBody!,
                color: context.colorPalette.neutral.grey3,
                style: context.typography.bodyMedium,
                maxLines: 2,
              ),

            // ── Platforms ──
            if (ad.publisherPlatforms != null &&
                ad.publisherPlatforms!.isNotEmpty)
              _InfoRowWidget(
                icon: Icons.share_rounded,
                label: ad.publisherPlatforms!
                    .map(_capitalise)
                    .join(' · '),
                color: context.colorPalette.neutral.grey4,
              ),

            // ── Target gender / ages ──
            if (ad.targetGender != null || ad.targetAges != null) ...[
              _InfoRowWidget(
                icon: Icons.people_outline_rounded,
                label: _targetLabel(ad),
                color: context.colorPalette.neutral.grey4,
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
                color: context.colorPalette.neutral.grey4,
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
                color: context.colorPalette.neutral.grey4,
              ),

            // ── Reach (EU / BR) ──
            if (ad.euTotalReach != null || ad.brTotalReach != null)
              _InfoRowWidget(
                icon: Icons.public_rounded,
                label: _reachLabel(ad),
                color: context.colorPalette.neutral.grey4,
              ),

            // ── Creation date ──
            if (ad.adCreationTime != null)
              _InfoRowWidget(
                icon: Icons.calendar_today_outlined,
                label: ad.adCreationTime!.length >= 10
                    ? ad.adCreationTime!.substring(0, 10)
                    : ad.adCreationTime!,
                color: context.colorPalette.neutral.grey5,
                style: context.typography.labelSmall,
              ),
          ],
        ),
      ),
    );
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  String _targetLabel(FbAdEntity ad) {
    final parts = <String>[];
    if (ad.targetGender != null) parts.add(ad.targetGender!);
    if (ad.targetAges != null && ad.targetAges!.isNotEmpty) {
      parts.add(ad.targetAges!.join(', '));
    }
    return parts.join(' · ');
  }

  String _rangeLabel(int? lower, int? upper,
      {String prefix = '', String suffix = ''}) {
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

// ---------------------------------------------------------------------------
// Delivery status badge
// ---------------------------------------------------------------------------

class _DeliveryBadgeWidget extends StatelessWidget {
  const _DeliveryBadgeWidget({required this.isActive});

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? context.colorPalette.semantic.success
        : context.colorPalette.neutral.grey5;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.space(factor: 0.75),
        vertical: context.space(factor: 0.25),
      ),
      decoration: BoxDecoration(
        color: color.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(context.dimen.radiusLevel1.value),
        border: Border.all(color: color.color.withValues(alpha: 0.4)),
      ),
      child: DSTextWidget(
        isActive ? 'Active' : 'Stopped',
        color: color,
        style: context.typography.labelSmall,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Info row — mirrors _ItemWidget from AdPanelWidget
// ---------------------------------------------------------------------------

class _InfoRowWidget extends StatelessWidget {
  const _InfoRowWidget({
    required this.icon,
    required this.label,
    required this.color,
    this.style,
    this.maxLines = 1,
  });

  final IconData icon;
  final String label;
  final DSColor color;
  final DSTextStyle? style;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: maxLines > 1
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.center,
      children: [
        DSIconWidget(icon, size: DSIconSize.small, color: color),
        const DSHorizontalSpacerWidget(0.5),
        Flexible(
          child: DSTextWidget(
            label,
            color: color,
            style: style ?? context.typography.bodyMedium,
            maxLines: maxLines,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

