import 'package:json_annotation/json_annotation.dart';

part 'fb_page_info_model.g.dart';

@JsonSerializable()
class FbPageInfoModel {
  const FbPageInfoModel({
    required this.id,
    this.name,
    this.about,
    this.description,
    this.emails,
    this.phone,
    this.website,
    this.category,
    this.link,
    this.fanCount,
    this.verificationStatus,
    this.founded,
    this.locationCity,
    this.locationCountry,
    this.locationState,
    this.locationStreet,
    this.locationZip,
  });

  factory FbPageInfoModel.fromJson(Map<String, dynamic> json) =>
      _$FbPageInfoModelFromJson(json);

  final String id;
  final String? name;
  final String? about;
  final String? description;
  final List<String>? emails;
  final String? phone;
  final String? website;
  final String? category;

  /// URL to the Facebook Page.
  final String? link;

  /// Number of people who like the page.
  @JsonKey(name: 'fan_count')
  final int? fanCount;

  /// `not_verified`, `blue_verified`, or `gray_verified`.
  @JsonKey(name: 'verification_status')
  final String? verificationStatus;

  final String? founded;

  // location sub-fields extracted by read helpers.
  @JsonKey(name: 'location_city', readValue: _readCity)
  final String? locationCity;

  @JsonKey(name: 'location_country', readValue: _readCountry)
  final String? locationCountry;

  @JsonKey(name: 'location_state', readValue: _readState)
  final String? locationState;

  @JsonKey(name: 'location_street', readValue: _readStreet)
  final String? locationStreet;

  @JsonKey(name: 'location_zip', readValue: _readZip)
  final String? locationZip;

  Map<String, dynamic> toJson() => _$FbPageInfoModelToJson(this);
}

// ---------------------------------------------------------------------------
// Location read helpers
// ---------------------------------------------------------------------------

Object? _readCity(Map<dynamic, dynamic> json, String key) =>
    (json['location'] as Map<dynamic, dynamic>?)?['city']?.toString();

Object? _readCountry(Map<dynamic, dynamic> json, String key) =>
    (json['location'] as Map<dynamic, dynamic>?)?['country']?.toString();

Object? _readState(Map<dynamic, dynamic> json, String key) =>
    (json['location'] as Map<dynamic, dynamic>?)?['state']?.toString();

Object? _readStreet(Map<dynamic, dynamic> json, String key) =>
    (json['location'] as Map<dynamic, dynamic>?)?['street']?.toString();

Object? _readZip(Map<dynamic, dynamic> json, String key) =>
    (json['location'] as Map<dynamic, dynamic>?)?['zip']?.toString();

