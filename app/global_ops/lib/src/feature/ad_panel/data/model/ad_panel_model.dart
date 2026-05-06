import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/data/model/geo_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ad_panel_model.g.dart';

@JsonSerializable(explicitToJson: true)
class AdPanelModel {
  AdPanelModel({
    required this.campaign,
    required this.expression,
    required this.faceNumber,
    required this.key,
    required this.latitude,
    required this.longitude,
    required this.mediaType,
    required this.municipalityPart,
    required this.objectNumber,
    required this.objectFaceId,
    required this.station,
    required this.street,
    required this.yyyyww,
    required this.geo,
    required this.distanceInKm,
    this.objectCampaignIssue,
    this.objectAdvertisementIssue,
    this.objectDamageIssue,
    this.objectCleanIssue,
    this.objectPosterIssue,
    this.objectLighteningIssue,
    this.objectMaintenanceIssue,
    this.additionalComments,
    this.images,
    this.updatedBy,
    this.updatedAt,
  });

  factory AdPanelModel.fromJson(Map<String, dynamic> json) =>
      _$AdPanelModelFromJson(json);

  factory AdPanelModel.test() {
    return AdPanelModel(
      key: '202530_1-0223.2',
      campaign: 'Test Campaign',
      expression: 'Test Campaign v2',
      faceNumber: 2,
      latitude: 52.10460814,
      longitude: 4.28639859,
      mediaType: 'ABRI',
      municipalityPart: "'S-GRAVENHAGE",
      objectNumber: '1-0223',
      objectFaceId: '1-0223.2',
      station: 'HARINGKADE',
      street: 'NIEUWE DUINWEG',
      yyyyww: 202530,
      geo: GeoModel(
        geohash: 'xn76urx66',
        geopoint: const GeoPoint(35.681236, 139.767125),
      ),
      distanceInKm: 0.0,
      objectCampaignIssue: false,
      objectAdvertisementIssue: false,
      objectDamageIssue: false,
      objectCleanIssue: false,
      objectPosterIssue: false,
      objectLighteningIssue: false,
      objectMaintenanceIssue: false,
      additionalComments: '',
      images: const [],
    );
  }

  Map<String, dynamic> toJson() => _$AdPanelModelToJson(this);

  static Map<String, dynamic>? geoFirePointToJson(GeoFirePoint? point) =>
      point?.data;

  @JsonKey(name: 'CAMPAIGN')
  final String? campaign;

  @JsonKey(name: 'EXPRESSION')
  final String? expression;

  @JsonKey(name: 'FACENR')
  final int? faceNumber;

  @JsonKey(name: 'KEY')
  final String? key;

  @JsonKey(name: 'LATITUDE')
  final double? latitude;

  @JsonKey(name: 'LONGITUDE')
  final double? longitude;

  @JsonKey(name: 'MEDIA_TYPE')
  final String? mediaType;

  @JsonKey(name: 'MUNICIPALITY_PART')
  final String? municipalityPart;

  @JsonKey(name: 'OBJECTNR')
  final String? objectNumber;

  @JsonKey(name: 'OBJECT_FACE_ID')
  final String? objectFaceId;

  @JsonKey(name: 'STATION')
  final String? station;

  @JsonKey(name: 'STREET')
  final String? street;

  @JsonKey(name: 'YYYYWW')
  final int? yyyyww;

  @JsonKey(name: 'OBJECT_CAMPAIGN_ISSUE')
  final bool? objectCampaignIssue;

  @JsonKey(name: 'OBJECT_ADVERTISEMENT_ISSUE')
  final bool? objectAdvertisementIssue;

  @JsonKey(name: 'OBJECT_DAMAGE_ISSUE')
  final bool? objectDamageIssue;

  @JsonKey(name: 'OBJECT_CLEAN_ISSUE')
  final bool? objectCleanIssue;

  @JsonKey(name: 'OBJECT_POSTER_ISSUE')
  final bool? objectPosterIssue;

  @JsonKey(name: 'OBJECT_LIGHTENING_ISSUE')
  final bool? objectLighteningIssue;

  @JsonKey(name: 'OBJECT_MAINTENANCE_ISSUE')
  final bool? objectMaintenanceIssue;

  @JsonKey(name: 'ADDITIONAL_COMMENTS')
  final String? additionalComments;

  @JsonKey(name: 'IMAGES')
  final List<String>? images;

  @JsonKey(name: 'UPDATED_BY')
  final String? updatedBy;

  @JsonKey(name: 'UPDATED_AT')
  final String? updatedAt;

  @JsonKey(name: 'geo')
  final GeoModel? geo;

  @JsonKey(name: 'distanceInKm')
  final double? distanceInKm;

  AdPanelModel copyWith({
    String? campaign,
    String? expression,
    int? faceNumber,
    String? key,
    double? latitude,
    double? longitude,
    String? mediaType,
    String? municipalityPart,
    String? objectNumber,
    String? objectFaceId,
    String? station,
    String? street,
    int? yyyyww,
    GeoModel? geo,
    double? distanceInKm,
    bool? objectCampaignIssue,
    bool? objectAdvertisementIssue,
    bool? objectDamageIssue,
    bool? objectCleanIssue,
    bool? objectPosterIssue,
    bool? objectLighteningIssue,
    bool? objectMaintenanceIssue,
    String? additionalComments,
    List<String>? images,
    String? updatedBy,
    String? updatedAt,
  }) {
    return AdPanelModel(
      campaign: campaign ?? this.campaign,
      expression: expression ?? this.expression,
      faceNumber: faceNumber ?? this.faceNumber,
      key: key ?? this.key,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      mediaType: mediaType ?? this.mediaType,
      municipalityPart: municipalityPart ?? this.municipalityPart,
      objectNumber: objectNumber ?? this.objectNumber,
      objectFaceId: objectFaceId ?? this.objectFaceId,
      station: station ?? this.station,
      street: street ?? this.street,
      yyyyww: yyyyww ?? this.yyyyww,
      geo: geo ?? this.geo,
      distanceInKm: distanceInKm ?? this.distanceInKm,
      objectCampaignIssue: objectCampaignIssue ?? this.objectCampaignIssue,
      objectAdvertisementIssue:
          objectAdvertisementIssue ?? this.objectAdvertisementIssue,
      objectDamageIssue: objectDamageIssue ?? this.objectDamageIssue,
      objectCleanIssue: objectCleanIssue ?? this.objectCleanIssue,
      objectPosterIssue: objectPosterIssue ?? this.objectPosterIssue,
      objectLighteningIssue:
          objectLighteningIssue ?? this.objectLighteningIssue,
      objectMaintenanceIssue:
          objectMaintenanceIssue ?? this.objectMaintenanceIssue,
      additionalComments: additionalComments ?? this.additionalComments,
      images: images ?? this.images,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
