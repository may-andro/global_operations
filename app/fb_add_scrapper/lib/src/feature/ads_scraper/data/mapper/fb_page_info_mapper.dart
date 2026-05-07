import 'package:core/core.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/fb_page_info_model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/fb_page_info_entity.dart';

class FbPageInfoMapper implements Mapper<FbPageInfoModel, FbPageInfoEntity> {
  const FbPageInfoMapper();

  @override
  FbPageInfoEntity map(FbPageInfoModel model) {
    return FbPageInfoEntity(
      id: model.id,
      name: model.name,
      about: model.about,
      description: model.description,
      emails: model.emails,
      phone: model.phone,
      website: model.website,
      category: model.category,
      link: model.link,
      fanCount: model.fanCount,
      verificationStatus: model.verificationStatus,
      founded: model.founded,
      locationCity: model.locationCity,
      locationCountry: model.locationCountry,
      locationState: model.locationState,
      locationStreet: model.locationStreet,
      locationZip: model.locationZip,
    );
  }
}

