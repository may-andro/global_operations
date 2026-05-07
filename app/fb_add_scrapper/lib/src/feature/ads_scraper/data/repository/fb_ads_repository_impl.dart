import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/repository/fb_ads_repository.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/service/service.dart';
import 'package:firebase/firebase.dart';

/// Firestore collection where scraped ads are persisted.
const _kAdsCollection = 'scraped_ads';

class FbAdsRepositoryImpl implements FbAdsRepository {
  FbAdsRepositoryImpl({
    required this.apiService,
    required this.firestoreController,
  });

  final FbAdsApiService apiService;
  final FbFirestoreController firestoreController;

  // --------------------------------------------------------------------------
  // API
  // --------------------------------------------------------------------------

  @override
  Future<FbAdsResponseModel> searchAds({
    required String accessToken,
    required List<String> countries,
    String searchTerms = '',
    String adType = 'ALL',
    String? pageId,
    String? afterCursor,
    int limit = 50,
  }) =>
      apiService.searchAds(
        accessToken: accessToken,
        countries: countries,
        searchTerms: searchTerms,
        adType: adType,
        pageId: pageId,
        afterCursor: afterCursor,
        limit: limit,
      );

  // --------------------------------------------------------------------------
  // Firestore – deduplication via document ID = ad_archive_id
  // --------------------------------------------------------------------------

  @override
  Future<void> saveAds(List<FbAdModel> ads) async {
    if (ads.isEmpty) return;

    for (final ad in ads) {
      final data = ad
          .copyWith(scrapedAt: DateTime.now().toUtc().toIso8601String())
          .toJson();

      // addDocumentToCollection uses .set() which is idempotent – existing
      // documents with the same ID are overwritten, preventing duplicates.
      await firestoreController.addDocumentToCollection(
        collectionPath: _kAdsCollection,
        documentPath: ad.id,
        data: data,
      );
    }
  }

  @override
  Future<List<FbAdModel>> getSavedAds({
    int? limit,
    String? startAfterDocId,
  }) async {
    final rawList = await firestoreController.getCollectionQuerySnapshot(
      _kAdsCollection,
      orderBy: 'scraped_at',
      descending: true,
      limit: limit,
      startAfterDocumentId: startAfterDocId,
    );

    return rawList
        .map((json) => FbAdModel.fromJson(json))
        .toList();
  }

  @override
  Future<FbAdModel?> getSavedAdById(String adArchiveId) async {
    try {
      final raw = await firestoreController.getDocumentFromCollection(
        _kAdsCollection,
        adArchiveId,
      );
      if (raw == null) return null;
      return FbAdModel.fromJson(raw);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> deleteAd(String adArchiveId) =>
      firestoreController.deleteDocumentFromCollection(
        collectionPath: _kAdsCollection,
        documentPath: adArchiveId,
      );
}

