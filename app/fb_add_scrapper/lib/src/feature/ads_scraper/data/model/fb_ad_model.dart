import 'package:json_annotation/json_annotation.dart';

part 'fb_ad_model.g.dart';

@JsonSerializable()
class FbAdModel {
  const FbAdModel({
    required this.id,
    this.adCreativeBodies,
    this.adCreativeLinkTitles,
    this.adCreativeLinkDescriptions,
    this.adCreativeLinkCaptions,
    this.adCreativeLinkUrls,
    this.adCreationTime,
    this.adDeliveryStartTime,
    this.adDeliveryStopTime,
    this.adSnapshotUrl,
    this.bylines,
    this.currency,
    this.fundingEntity,
    this.pageId,
    this.pageName,
    this.impressionsLowerBound,
    this.impressionsUpperBound,
    this.spendLowerBound,
    this.spendUpperBound,
    this.languages,
    this.publisherPlatforms,
    this.targetAges,
    this.targetGender,
    this.targetLocations,
    this.euTotalReach,
    this.brTotalReach,
    this.estimatedAudienceSizeLowerBound,
    this.estimatedAudienceSizeUpperBound,
    this.demographicDistribution,
    this.deliveryByRegion,
    this.beneficiaryPayers,
    this.scrapedAt,
    this.advertiserId,
    this.rankScore,
    this.totalAdsFound,
    this.latestAdTime,
    this.websiteDomain,
  });

  factory FbAdModel.fromJson(Map<String, dynamic> json) =>
      _$FbAdModelFromJson(json);
  @JsonKey(name: 'advertiser_id')
  final String? advertiserId;

  @JsonKey(name: 'rank_score')
  final double? rankScore;

  @JsonKey(name: 'total_ads_found')
  final int? totalAdsFound;

  @JsonKey(name: 'latest_ad_time')
  final String? latestAdTime;

  /// The unique `ad_archive_id` – used as Firestore document key for dedup.
  final String id;

  @JsonKey(name: 'ad_creative_bodies')
  final List<String>? adCreativeBodies;

  @JsonKey(name: 'ad_creative_link_titles')
  final List<String>? adCreativeLinkTitles;

  @JsonKey(name: 'ad_creative_link_descriptions')
  final List<String>? adCreativeLinkDescriptions;

  @JsonKey(name: 'ad_creative_link_captions')
  final List<String>? adCreativeLinkCaptions;

  @JsonKey(name: 'ad_creative_link_urls')
  final List<String>? adCreativeLinkUrls;

  @JsonKey(name: 'ad_creation_time')
  final String? adCreationTime;

  @JsonKey(name: 'ad_delivery_start_time')
  final String? adDeliveryStartTime;

  @JsonKey(name: 'ad_delivery_stop_time')
  final String? adDeliveryStopTime;

  @JsonKey(name: 'ad_snapshot_url')
  final String? adSnapshotUrl;

  /// Funding entity / payer of the ad (political ads). Maps to `bylines`.
  @JsonKey(name: 'bylines')
  final String? bylines;

  /// ISO currency code. Only populated for POLITICAL_AND_ISSUE_ADS.
  final String? currency;

  @JsonKey(name: 'funding_entity')
  final String? fundingEntity;

  @JsonKey(name: 'page_id')
  final String? pageId;

  @JsonKey(name: 'page_name')
  final String? pageName;

  // impressions: { lower_bound, upper_bound } — POLITICAL_AND_ISSUE_ADS only.
  @JsonKey(name: 'impressions_lower_bound', readValue: _readImpressionsLower)
  final int? impressionsLowerBound;

  @JsonKey(name: 'impressions_upper_bound', readValue: _readImpressionsUpper)
  final int? impressionsUpperBound;

  // spend: { lower_bound, upper_bound } — POLITICAL_AND_ISSUE_ADS only.
  @JsonKey(name: 'spend_lower_bound', readValue: _readSpendLower)
  final int? spendLowerBound;

  @JsonKey(name: 'spend_upper_bound', readValue: _readSpendUpper)
  final int? spendUpperBound;

  final List<String>? languages;

  @JsonKey(name: 'publisher_platforms')
  final List<String>? publisherPlatforms;

  /// Age ranges used for targeting in UK & EU, e.g. ['18-24', '25-34'].
  @JsonKey(name: 'target_ages')
  final List<String>? targetAges;

  /// Gender used for targeting in UK & EU: 'Women', 'Men', or 'All'.
  @JsonKey(name: 'target_gender')
  final String? targetGender;

  /// Location names used for targeting in UK & EU.
  /// Extracted from the `target_locations` array of `{name, type}` objects.
  @JsonKey(name: 'target_locations', readValue: _readTargetLocationNames)
  final List<String>? targetLocations;

  /// Estimated combined reach inside the EU.
  @JsonKey(name: 'eu_total_reach')
  final int? euTotalReach;

  /// Estimated reach in Brazil (POLITICAL_AND_ISSUE_ADS delivered to Brazil).
  @JsonKey(name: 'br_total_reach')
  final int? brTotalReach;

  // estimated_audience_size: { lower_bound, upper_bound } — POLITICAL only.
  @JsonKey(
    name: 'estimated_audience_size_lower_bound',
    readValue: _readEstimatedAudienceLower,
  )
  final int? estimatedAudienceSizeLowerBound;

  @JsonKey(
    name: 'estimated_audience_size_upper_bound',
    readValue: _readEstimatedAudienceUpper,
  )
  final int? estimatedAudienceSizeUpperBound;

  /// Age/gender distribution of reached accounts — POLITICAL_AND_ISSUE_ADS.
  /// Each entry: `{age: '18-24', gender: 'Male', percentage: 5.0}`.
  @JsonKey(name: 'demographic_distribution')
  final List<Map<String, dynamic>>? demographicDistribution;

  /// Regional delivery distribution — POLITICAL_AND_ISSUE_ADS.
  /// Each entry: `{region: 'Noord-Holland', percentage: 12.0}`.
  @JsonKey(name: 'delivery_by_region')
  final List<Map<String, dynamic>>? deliveryByRegion;

  /// Reported beneficiaries and payers — EU ads only.
  /// Extracted as display strings "Beneficiary / Payer".
  @JsonKey(name: 'beneficiary_payers', readValue: _readBeneficiaryPayers)
  final List<String>? beneficiaryPayers;

  @JsonKey(name: 'scraped_at')
  final String? scrapedAt;

  @JsonKey(name: 'website_domain')
  final String? websiteDomain;

  Map<String, dynamic> toJson() => _$FbAdModelToJson(this);

  FbAdModel copyWith({
    String? id,
    List<String>? adCreativeBodies,
    List<String>? adCreativeLinkTitles,
    List<String>? adCreativeLinkDescriptions,
    List<String>? adCreativeLinkCaptions,
    List<String>? adCreativeLinkUrls,
    String? adCreationTime,
    String? adDeliveryStartTime,
    String? adDeliveryStopTime,
    String? adSnapshotUrl,
    String? bylines,
    String? currency,
    String? fundingEntity,
    String? pageId,
    String? pageName,
    int? impressionsLowerBound,
    int? impressionsUpperBound,
    int? spendLowerBound,
    int? spendUpperBound,
    List<String>? languages,
    List<String>? publisherPlatforms,
    List<String>? targetAges,
    String? targetGender,
    List<String>? targetLocations,
    int? euTotalReach,
    int? brTotalReach,
    int? estimatedAudienceSizeLowerBound,
    int? estimatedAudienceSizeUpperBound,
    List<Map<String, dynamic>>? demographicDistribution,
    List<Map<String, dynamic>>? deliveryByRegion,
    List<String>? beneficiaryPayers,
    String? scrapedAt,
    String? advertiserId,
    double? rankScore,
    int? totalAdsFound,
    String? latestAdTime,
    String? websiteDomain,
  }) {
    return FbAdModel(
      id: id ?? this.id,
      adCreativeBodies: adCreativeBodies ?? this.adCreativeBodies,
      adCreativeLinkTitles: adCreativeLinkTitles ?? this.adCreativeLinkTitles,
      adCreativeLinkDescriptions:
          adCreativeLinkDescriptions ?? this.adCreativeLinkDescriptions,
      adCreativeLinkCaptions:
          adCreativeLinkCaptions ?? this.adCreativeLinkCaptions,
      adCreativeLinkUrls: adCreativeLinkUrls ?? this.adCreativeLinkUrls,
      adCreationTime: adCreationTime ?? this.adCreationTime,
      adDeliveryStartTime: adDeliveryStartTime ?? this.adDeliveryStartTime,
      adDeliveryStopTime: adDeliveryStopTime ?? this.adDeliveryStopTime,
      adSnapshotUrl: adSnapshotUrl ?? this.adSnapshotUrl,
      bylines: bylines ?? this.bylines,
      currency: currency ?? this.currency,
      fundingEntity: fundingEntity ?? this.fundingEntity,
      pageId: pageId ?? this.pageId,
      pageName: pageName ?? this.pageName,
      impressionsLowerBound:
          impressionsLowerBound ?? this.impressionsLowerBound,
      impressionsUpperBound:
          impressionsUpperBound ?? this.impressionsUpperBound,
      spendLowerBound: spendLowerBound ?? this.spendLowerBound,
      spendUpperBound: spendUpperBound ?? this.spendUpperBound,
      languages: languages ?? this.languages,
      publisherPlatforms: publisherPlatforms ?? this.publisherPlatforms,
      targetAges: targetAges ?? this.targetAges,
      targetGender: targetGender ?? this.targetGender,
      targetLocations: targetLocations ?? this.targetLocations,
      euTotalReach: euTotalReach ?? this.euTotalReach,
      brTotalReach: brTotalReach ?? this.brTotalReach,
      estimatedAudienceSizeLowerBound:
          estimatedAudienceSizeLowerBound ??
          this.estimatedAudienceSizeLowerBound,
      estimatedAudienceSizeUpperBound:
          estimatedAudienceSizeUpperBound ??
          this.estimatedAudienceSizeUpperBound,
      demographicDistribution:
          demographicDistribution ?? this.demographicDistribution,
      deliveryByRegion: deliveryByRegion ?? this.deliveryByRegion,
      beneficiaryPayers: beneficiaryPayers ?? this.beneficiaryPayers,
      scrapedAt: scrapedAt ?? this.scrapedAt,
      advertiserId: advertiserId ?? this.advertiserId,
      rankScore: rankScore ?? this.rankScore,
      totalAdsFound: totalAdsFound ?? this.totalAdsFound,
      latestAdTime: latestAdTime ?? this.latestAdTime,
      websiteDomain: websiteDomain ?? this.websiteDomain,
    );
  }
}

// ---------------------------------------------------------------------------
// JSON read helpers
// ---------------------------------------------------------------------------

Object? _readImpressionsLower(Map<dynamic, dynamic> json, String key) {
  final impressions = json['impressions'];
  if (impressions is Map) {
    final v = impressions['lower_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readImpressionsUpper(Map<dynamic, dynamic> json, String key) {
  final impressions = json['impressions'];
  if (impressions is Map) {
    final v = impressions['upper_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readSpendLower(Map<dynamic, dynamic> json, String key) {
  final spend = json['spend'];
  if (spend is Map) {
    final v = spend['lower_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readSpendUpper(Map<dynamic, dynamic> json, String key) {
  final spend = json['spend'];
  if (spend is Map) {
    final v = spend['upper_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readEstimatedAudienceLower(Map<dynamic, dynamic> json, String key) {
  final eas = json['estimated_audience_size'];
  if (eas is Map) {
    final v = eas['lower_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readEstimatedAudienceUpper(Map<dynamic, dynamic> json, String key) {
  final eas = json['estimated_audience_size'];
  if (eas is Map) {
    final v = eas['upper_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

/// Extracts `name` strings from  [{name: 'Netherlands', type: 'COUNTRY'}, …]
Object? _readTargetLocationNames(Map<dynamic, dynamic> json, String key) {
  final list = json['target_locations'];
  if (list is! List) return null;
  return list
      .whereType<Map<dynamic, dynamic>>()
      .map((e) => e['name']?.toString())
      .whereType<String>()
      .toList();
}

/// Flattens [{beneficiary: 'X', payer: 'Y'}, …] to ['X / Y', …]
Object? _readBeneficiaryPayers(Map<dynamic, dynamic> json, String key) {
  final list = json['beneficiary_payers'];
  if (list is! List) return null;
  return list
      .whereType<Map<dynamic, dynamic>>()
      .map((e) {
        final b = e['beneficiary']?.toString() ?? '';
        final p = e['payer']?.toString() ?? '';
        return p.isNotEmpty && p != b ? '$b / $p' : b;
      })
      .where((s) => s.isNotEmpty)
      .toList();
}
