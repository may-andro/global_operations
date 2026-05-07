import 'package:core/core.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/mapper/fb_ad_mapper.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/fb_ads_search_result_model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/fb_ads_search_result_entity.dart';

class FbAdsSearchResultMapper
    implements Mapper<FbAdsSearchResultModel, FbAdsSearchResultEntity> {
  const FbAdsSearchResultMapper(this._fbAdMapper);

  final FbAdMapper _fbAdMapper;

  @override
  FbAdsSearchResultEntity map(FbAdsSearchResultModel from) {
    return FbAdsSearchResultEntity(
      ads: from.ads.map(_fbAdMapper.to).toList(),
      nextCursor: from.nextCursor,
      hasNextPage: from.hasNextPage,
    );
  }
}

