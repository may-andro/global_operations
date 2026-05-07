import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';

abstract class FbAdsRepository {
  /// Fetches a page of ads from the Facebook Ads Library API.
  Future<FbAdsResponseEntity> searchAds({
    required String accessToken,
    required List<String> countries,
    String searchTerms,
    String adType,
    String? pageId,
    String? afterCursor,
    int limit,
  });

  /// Saves a list of ads to Firestore, using [FbAdEntity.id] as the document
  /// key so duplicates are idempotently overwritten.
  Future<void> saveAds(List<FbAdEntity> ads);

  /// Retrieves all previously saved ads from Firestore.
  Future<List<FbAdEntity>> getSavedAds({int? limit, String? startAfterDocId});

  /// Fetches a single saved ad by its archive ID.
  Future<FbAdEntity?> getSavedAdById(String adArchiveId);

  /// Deletes a saved ad from Firestore.
  Future<void> deleteAd(String adArchiveId);
}

