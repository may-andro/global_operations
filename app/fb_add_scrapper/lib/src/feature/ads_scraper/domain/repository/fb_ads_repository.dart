import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';

abstract class FbAdsRepository {
  // --------------------------------------------------------------------------
  // Firestore-backed scrape flow
  // --------------------------------------------------------------------------

  /// Triggers the Cloud Function to scrape up to 1000 ads and store them in
  /// Firestore. Returns the [termId] (slugified search term) immediately.
  Future<String> triggerScrape({required String searchTerms, String adType});

  /// Streams live status updates for a single search term document.
  Stream<SearchTermEntity?> watchSearchTerm(String termId);

  /// Streams the list of all search terms, ordered newest-first.
  Stream<List<SearchTermEntity>> watchSearchTerms();

  /// Fetches a paginated page of ads stored under a search term.
  Future<List<FbAdEntity>> getAdsForTerm(
    String termId, {
    int? limit,
    String? startAfterDocId,
  });

  /// Fetches public advertiser/page info via the Cloud Function.
  Future<FbPageInfoEntity?> getPageInfo({required String pageId});
}
