import 'package:json_annotation/json_annotation.dart';

part 'fb_ad_model.g.dart';

@JsonSerializable()
class FbAdModel {
  const FbAdModel({
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
    this.scrapedAt,
  });

  factory FbAdModel.fromJson(Map<String, dynamic> json) =>
      _$FbAdModelFromJson(json);

  /// The unique `ad_archive_id` – used as Firestore document key for dedup.
  final String id;

  @JsonKey(name: 'ad_creative_body')
  final String? adCreativeBody;

  @JsonKey(name: 'ad_creative_link_caption')
  final String? adCreativeLinkCaption;

  @JsonKey(name: 'ad_creative_link_description')
  final String? adCreativeLinkDescription;

  @JsonKey(name: 'ad_creative_link_title')
  final String? adCreativeLinkTitle;

  @JsonKey(name: 'ad_creative_link_url')
  final String? adCreativeLinkUrl;

  @JsonKey(name: 'ad_creation_time')
  final String? adCreationTime;

  @JsonKey(name: 'ad_delivery_start_time')
  final String? adDeliveryStartTime;

  @JsonKey(name: 'ad_delivery_stop_time')
  final String? adDeliveryStopTime;

  @JsonKey(name: 'ad_snapshot_url')
  final String? adSnapshotUrl;

  final String? currency;

  @JsonKey(name: 'funding_entity')
  final String? fundingEntity;

  @JsonKey(name: 'page_id')
  final String? pageId;

  @JsonKey(name: 'page_name')
  final String? pageName;

  @JsonKey(name: 'impressions_lower_bound', readValue: _readImpressionsLower)
  final int? impressionsLowerBound;

  @JsonKey(name: 'impressions_upper_bound', readValue: _readImpressionsUpper)
  final int? impressionsUpperBound;

  @JsonKey(name: 'spend_lower_bound', readValue: _readSpendLower)
  final int? spendLowerBound;

  @JsonKey(name: 'spend_upper_bound', readValue: _readSpendUpper)
  final int? spendUpperBound;

  final List<String>? languages;

  @JsonKey(name: 'publisher_platforms')
  final List<String>? publisherPlatforms;

  @JsonKey(name: 'scraped_at')
  final String? scrapedAt;

  Map<String, dynamic> toJson() => _$FbAdModelToJson(this);

  FbAdModel copyWith({
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
    String? scrapedAt,
  }) {
    return FbAdModel(
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
      scrapedAt: scrapedAt ?? this.scrapedAt,
    );
  }
}

// Helpers to extract nested impressions/spend objects from the API response.
// API returns: "impressions": {"lower_bound": "1000", "upper_bound": "5000"}
Object? _readImpressionsLower(Map json, String key) {
  final impressions = json['impressions'];
  if (impressions is Map) {
    final v = impressions['lower_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readImpressionsUpper(Map json, String key) {
  final impressions = json['impressions'];
  if (impressions is Map) {
    final v = impressions['upper_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readSpendLower(Map json, String key) {
  final spend = json['spend'];
  if (spend is Map) {
    final v = spend['lower_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

Object? _readSpendUpper(Map json, String key) {
  final spend = json['spend'];
  if (spend is Map) {
    final v = spend['upper_bound'];
    if (v is String) return int.tryParse(v);
    if (v is int) return v;
  }
  return null;
}

