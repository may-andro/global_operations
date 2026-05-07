import 'package:equatable/equatable.dart';

class FbAdEntity extends Equatable {
  const FbAdEntity({
    required this.id,
    this.adCreativeBody,
    this.adCreativeLinkCaption,
    this.adCreativeLinkDescription,
    this.adCreativeLinkTitle,
    this.adCreativeLinkUrl,
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
  });

  /// The unique `ad_archive_id` — used as Firestore document key for dedup.
  final String id;

  final String? adCreativeBody;
  final String? adCreativeLinkCaption;
  final String? adCreativeLinkDescription;
  final String? adCreativeLinkTitle;
  final String? adCreativeLinkUrl;
  final String? adCreationTime;
  final String? adDeliveryStartTime;
  final String? adDeliveryStopTime;
  final String? adSnapshotUrl;

  /// Funding entity / payer declared by the ad buyer (`bylines` API field).
  final String? bylines;

  /// ISO currency code. Only populated for POLITICAL_AND_ISSUE_ADS.
  final String? currency;
  final String? fundingEntity;
  final String? pageId;
  final String? pageName;

  // impressions — POLITICAL_AND_ISSUE_ADS only.
  final int? impressionsLowerBound;
  final int? impressionsUpperBound;

  // spend — POLITICAL_AND_ISSUE_ADS only.
  final int? spendLowerBound;
  final int? spendUpperBound;

  final List<String>? languages;
  final List<String>? publisherPlatforms;

  /// Age ranges used for targeting in UK & EU.
  final List<String>? targetAges;

  /// Gender used for targeting in UK & EU: 'Women', 'Men', or 'All'.
  final String? targetGender;

  /// Location names included/excluded for targeting in UK & EU.
  final List<String>? targetLocations;

  /// Estimated combined reach inside the EU.
  final int? euTotalReach;

  /// Estimated reach in Brazil.
  final int? brTotalReach;

  // estimated_audience_size — POLITICAL_AND_ISSUE_ADS only.
  final int? estimatedAudienceSizeLowerBound;
  final int? estimatedAudienceSizeUpperBound;

  /// Demographic distribution of reached accounts — POLITICAL_AND_ISSUE_ADS.
  final List<Map<String, dynamic>>? demographicDistribution;

  /// Regional delivery distribution — POLITICAL_AND_ISSUE_ADS.
  final List<Map<String, dynamic>>? deliveryByRegion;

  /// Reported beneficiaries and payers — EU ads only.
  final List<String>? beneficiaryPayers;

  final String? scrapedAt;

  @override
  List<Object?> get props => [
    id,
    adCreativeBody,
    adCreativeLinkCaption,
    adCreativeLinkDescription,
    adCreativeLinkTitle,
    adCreativeLinkUrl,
    adCreationTime,
    adDeliveryStartTime,
    adDeliveryStopTime,
    adSnapshotUrl,
    bylines,
    currency,
    fundingEntity,
    pageId,
    pageName,
    impressionsLowerBound,
    impressionsUpperBound,
    spendLowerBound,
    spendUpperBound,
    languages,
    publisherPlatforms,
    targetAges,
    targetGender,
    targetLocations,
    euTotalReach,
    brTotalReach,
    estimatedAudienceSizeLowerBound,
    estimatedAudienceSizeUpperBound,
    demographicDistribution,
    deliveryByRegion,
    beneficiaryPayers,
    scrapedAt,
  ];

  FbAdEntity copyWith({
    String? id,
    String? adCreativeBody,
    String? adCreativeLinkCaption,
    String? adCreativeLinkDescription,
    String? adCreativeLinkTitle,
    String? adCreativeLinkUrl,
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
  }) {
    return FbAdEntity(
      id: id ?? this.id,
      adCreativeBody: adCreativeBody ?? this.adCreativeBody,
      adCreativeLinkCaption:
          adCreativeLinkCaption ?? this.adCreativeLinkCaption,
      adCreativeLinkDescription:
          adCreativeLinkDescription ?? this.adCreativeLinkDescription,
      adCreativeLinkTitle: adCreativeLinkTitle ?? this.adCreativeLinkTitle,
      adCreativeLinkUrl: adCreativeLinkUrl ?? this.adCreativeLinkUrl,
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
    );
  }
}
