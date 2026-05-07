import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/repository/repository.dart';

/// Returns a [Stream] of [SearchTermEntity] list from Firestore.
///
/// This is a simple stream use case — not a [BaseUseCase] because it returns
/// a stream rather than a Future.
class WatchSearchTermsUseCase {
  WatchSearchTermsUseCase(this._repository);

  final FbAdsRepository _repository;

  Stream<List<SearchTermEntity>> call() => _repository.watchSearchTerms();
}

