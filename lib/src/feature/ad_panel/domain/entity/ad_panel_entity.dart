import 'package:core/core.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase/firebase.dart';

class AdPanelEntity extends Equatable {
  const AdPanelEntity({
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
    required this.objectCampaignIssue,
    required this.objectAdvertisementIssue,
    required this.objectDamageIssue,
    required this.objectCleanIssue,
    required this.objectPosterIssue,
    required this.objectLighteningIssue,
    required this.objectMaintenanceIssue,
    this.additionalComments,
    this.images,
    this.updatedBy,
    this.updatedAt,
  });

  final String campaign;
  final String expression;
  final int faceNumber;
  final String key;
  final double latitude;
  final double longitude;
  final String mediaType;
  final String municipalityPart;
  final String objectNumber;
  final String objectFaceId;
  final String station;
  final String street;
  final int yyyyww;
  final GeoEntity geo;
  final double distanceInKm;
  final bool objectCampaignIssue;
  final bool objectAdvertisementIssue;
  final bool objectDamageIssue;
  final bool objectCleanIssue;
  final bool objectPosterIssue;
  final bool objectLighteningIssue;
  final bool objectMaintenanceIssue;
  final String? additionalComments;
  final List<String>? images;
  final String? updatedBy;
  final String? updatedAt;

  @override
  List<Object?> get props => [
    key,
    campaign,
    expression,
    faceNumber,
    latitude,
    longitude,
    mediaType,
    municipalityPart,
    objectNumber,
    objectFaceId,
    station,
    street,
    yyyyww,
    geo,
    distanceInKm,
    objectCampaignIssue,
    objectAdvertisementIssue,
    objectDamageIssue,
    objectCleanIssue,
    objectPosterIssue,
    objectLighteningIssue,
    objectMaintenanceIssue,
    additionalComments,
    images,
    updatedBy,
    updatedAt,
  ];

  String get address {
    return '${street.capitalize},\n${municipalityPart.capitalize}';
  }

  AdPanelEntity copyWith({
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
    GeoEntity? geo,
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
    return AdPanelEntity(
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

  bool get hasBeenEdited {
    return updatedAt != null && updatedBy != null;
  }
}

class GeoEntity extends Equatable {
  const GeoEntity({required this.geohash, required this.geopoint});

  final String geohash;
  final GeoPoint geopoint;

  @override
  List<Object?> get props => [geohash, geopoint];
}
