import 'package:core/core.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';

class FbAdMapper implements BiMapper<FbAdModel, FbAdEntity> {
  const FbAdMapper();

  @override
  FbAdModel from(FbAdEntity entity) {
    return FbAdModel(
      id: entity.id,
      adCreativeBody: entity.adCreativeBody,
      adCreativeLinkCaption: entity.adCreativeLinkCaption,
      adCreativeLinkDescription: entity.adCreativeLinkDescription,
      adCreativeLinkTitle: entity.adCreativeLinkTitle,
      adCreativeLinkUrl: entity.adCreativeLinkUrl,
      adCreationTime: entity.adCreationTime,
      adDeliveryStartTime: entity.adDeliveryStartTime,
      adDeliveryStopTime: entity.adDeliveryStopTime,
      adSnapshotUrl: entity.adSnapshotUrl,
      bylines: entity.bylines,
      currency: entity.currency,
      fundingEntity: entity.fundingEntity,
      pageId: entity.pageId,
      pageName: entity.pageName,
      impressionsLowerBound: entity.impressionsLowerBound,
      impressionsUpperBound: entity.impressionsUpperBound,
      spendLowerBound: entity.spendLowerBound,
      spendUpperBound: entity.spendUpperBound,
      languages: entity.languages,
      publisherPlatforms: entity.publisherPlatforms,
      targetAges: entity.targetAges,
      targetGender: entity.targetGender,
      targetLocations: entity.targetLocations,
      euTotalReach: entity.euTotalReach,
      brTotalReach: entity.brTotalReach,
      estimatedAudienceSizeLowerBound: entity.estimatedAudienceSizeLowerBound,
      estimatedAudienceSizeUpperBound: entity.estimatedAudienceSizeUpperBound,
      demographicDistribution: entity.demographicDistribution,
      deliveryByRegion: entity.deliveryByRegion,
      beneficiaryPayers: entity.beneficiaryPayers,
      scrapedAt: entity.scrapedAt,
    );
  }

  @override
  FbAdEntity to(FbAdModel model) {
    return FbAdEntity(
      id: model.id,
      adCreativeBody: model.adCreativeBody,
      adCreativeLinkCaption: model.adCreativeLinkCaption,
      adCreativeLinkDescription: model.adCreativeLinkDescription,
      adCreativeLinkTitle: model.adCreativeLinkTitle,
      adCreativeLinkUrl: model.adCreativeLinkUrl,
      adCreationTime: model.adCreationTime,
      adDeliveryStartTime: model.adDeliveryStartTime,
      adDeliveryStopTime: model.adDeliveryStopTime,
      adSnapshotUrl: model.adSnapshotUrl,
      bylines: model.bylines,
      currency: model.currency,
      fundingEntity: model.fundingEntity,
      pageId: model.pageId,
      pageName: model.pageName,
      impressionsLowerBound: model.impressionsLowerBound,
      impressionsUpperBound: model.impressionsUpperBound,
      spendLowerBound: model.spendLowerBound,
      spendUpperBound: model.spendUpperBound,
      languages: model.languages,
      publisherPlatforms: model.publisherPlatforms,
      targetAges: model.targetAges,
      targetGender: model.targetGender,
      targetLocations: model.targetLocations,
      euTotalReach: model.euTotalReach,
      brTotalReach: model.brTotalReach,
      estimatedAudienceSizeLowerBound: model.estimatedAudienceSizeLowerBound,
      estimatedAudienceSizeUpperBound: model.estimatedAudienceSizeUpperBound,
      demographicDistribution: model.demographicDistribution,
      deliveryByRegion: model.deliveryByRegion,
      beneficiaryPayers: model.beneficiaryPayers,
      scrapedAt: model.scrapedAt,
    );
  }
}
