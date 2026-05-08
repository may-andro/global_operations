import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/search_term_model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';

class SearchTermMapper {
  const SearchTermMapper();

  SearchTermEntity map(SearchTermModel model) {
    return SearchTermEntity(
      id: model.id,
      term: model.term,
      adType: model.adType,
      status: model.statusEnum,
      totalCount: model.totalCount,
      lastFetchedAt: model.lastFetchedAt,
      createdAt: model.createdAt,
      errorMessage: model.errorMessage,
    );
  }
}
