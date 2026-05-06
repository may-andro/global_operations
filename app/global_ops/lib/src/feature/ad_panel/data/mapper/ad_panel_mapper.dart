import 'package:core/core.dart';
import 'package:global_ops/src/feature/ad_panel/data/mapper/geo_mapper.dart';
import 'package:global_ops/src/feature/ad_panel/data/model/model.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

class AdPanelMapper implements BiMapper<AdPanelModel, AdPanelEntity?> {
  AdPanelMapper(this._geoMapper);

  final GeoMapper _geoMapper;

  @override
  AdPanelModel from(AdPanelEntity? from) {
    return AdPanelModel(
      key: from?.key,
      campaign: from?.campaign,
      expression: from?.expression,
      faceNumber: from?.faceNumber,
      latitude: from?.latitude,
      longitude: from?.longitude,
      mediaType: from?.mediaType,
      municipalityPart: from?.municipalityPart,
      objectNumber: from?.objectNumber,
      objectFaceId: from?.objectFaceId,
      station: from?.station,
      street: from?.street,
      yyyyww: from?.yyyyww,
      geo: from != null ? _geoMapper.from(from.geo) : null,
      distanceInKm: from?.distanceInKm,
      objectCampaignIssue: from?.objectCampaignIssue,
      objectAdvertisementIssue: from?.objectAdvertisementIssue,
      objectDamageIssue: from?.objectDamageIssue,
      objectCleanIssue: from?.objectCleanIssue,
      objectPosterIssue: from?.objectPosterIssue,
      objectLighteningIssue: from?.objectLighteningIssue,
      objectMaintenanceIssue: from?.objectMaintenanceIssue,
      additionalComments: from?.additionalComments,
      images: from?.images,
      updatedBy: from?.updatedBy,
      updatedAt: from?.updatedAt,
    );
  }

  @override
  AdPanelEntity? to(AdPanelModel from) {
    if (from.campaign == null ||
        from.yyyyww == null ||
        from.expression == null ||
        from.faceNumber == null ||
        from.key == null ||
        from.latitude == null ||
        from.longitude == null ||
        from.geo == null ||
        from.mediaType == null ||
        from.municipalityPart == null ||
        from.objectNumber == null ||
        from.objectFaceId == null ||
        from.station == null ||
        from.street == null) {
      return null;
    }
    return AdPanelEntity(
      key: from.key!,
      campaign: from.campaign!,
      expression: from.expression!,
      faceNumber: from.faceNumber!,
      latitude: from.latitude!,
      longitude: from.longitude!,
      mediaType: from.mediaType!,
      municipalityPart: from.municipalityPart!,
      objectNumber: from.objectNumber!,
      objectFaceId: from.objectFaceId!,
      station: from.station!,
      street: from.street!,
      yyyyww: from.yyyyww!,
      geo: _geoMapper.to(from.geo!),
      distanceInKm: from.distanceInKm ?? 0,
      objectCampaignIssue: from.objectCampaignIssue ?? false,
      objectAdvertisementIssue: from.objectAdvertisementIssue ?? false,
      objectDamageIssue: from.objectDamageIssue ?? false,
      objectCleanIssue: from.objectCleanIssue ?? false,
      objectPosterIssue: from.objectPosterIssue ?? false,
      objectLighteningIssue: from.objectLighteningIssue ?? false,
      objectMaintenanceIssue: from.objectMaintenanceIssue ?? false,
      additionalComments: from.additionalComments,
      images: from.images,
      updatedBy: from.updatedBy,
      updatedAt: from.updatedAt,
    );
  }
}
