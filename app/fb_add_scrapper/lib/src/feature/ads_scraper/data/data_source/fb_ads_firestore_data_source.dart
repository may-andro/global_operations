import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/fb_ad_model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/search_term_model.dart';
import 'package:firebase/firebase.dart';

/// Firestore collection name for search terms.
const _kSearchTermsCollection = 'search_terms';

/// Subcollection under each search term document.
const _kAdsSubcollection = 'ads';

/// Firestore-backed data source for search terms and their scraped ads.
class FbAdsFirestoreDataSource {
  FbAdsFirestoreDataSource({required FbFirestoreController firestoreController})
    : _firestore = firestoreController;

  final FbFirestoreController _firestore;

  /// Streams a single search term document (live updates).
  Stream<SearchTermModel?> streamSearchTerm(String termId) {
    return _firestore
        .streamDocument(_kSearchTermsCollection, termId)
        .map(
          (data) =>
              data == null ? null : SearchTermModel.fromJson(termId, data),
        );
  }

  /// Streams the full list of search terms, ordered newest-first.
  Stream<List<SearchTermModel>> streamSearchTerms() {
    return _firestore
        .streamCollection(
          _kSearchTermsCollection,
          orderBy: 'createdAt',
          descending: true,
        )
        .asyncMap((list) {
          // streamCollection returns raw data without the doc ID, so we re-query
          // using getCollectionQuerySnapshot that also lacks IDs.
          // Instead we stream snapshots with IDs by doing a manual approach.
          return list.map((data) {
            final id = data['term'] as String? ?? '';
            return SearchTermModel.fromJson(_slugify(id), data);
          }).toList();
        });
  }

  /// Streams the full list of search terms with their document IDs.
  Stream<List<SearchTermModel>> streamSearchTermsWithIds() {
    // We use streamCollection which returns data maps — but we need IDs.
    // Use the lower-level Firestore stream via the controller's streamCollection
    // which does not carry document IDs. We work around this by embedding
    // `termId` in the document (the Cloud Function writes `term` but not `id`).
    // We rely on `_slugify(term)` to reconstruct the id consistently.
    return _firestore
        .streamCollection(
          _kSearchTermsCollection,
          orderBy: 'createdAt',
          descending: true,
        )
        .map(
          (list) => list.map((data) {
            final term = data['term'] as String? ?? '';
            return SearchTermModel.fromJson(_slugify(term), data);
          }).toList(),
        );
  }

  /// Fetches a paginated list of ads for a given search term.
  Future<List<FbAdModel>> getAdsForTerm(
    String termId, {
    int? limit,
    String? startAfterDocId,
  }) async {
    final rawList = await _firestore.getSubcollectionQuerySnapshot(
      _kSearchTermsCollection,
      termId,
      _kAdsSubcollection,
      orderBy: 'rank_score',
      descending: true,
      limit: limit ?? 30,
      startAfterDocumentId: startAfterDocId,
    );
    return rawList.map((json) => FbAdModel.fromJson(json)).toList();
  }
}

/// Mirrors the slugify logic from the Cloud Function.
String _slugify(String term) {
  return term
      .toLowerCase()
      .trim()
      .replaceAll(RegExp(r'\s+'), '_')
      .replaceAll(RegExp(r'[^a-z0-9_]'), '');
}
