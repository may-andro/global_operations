import 'package:fb_add_scrapper/src/feature/ads_scraper/data/data_source/fb_ads_cloud_function_data_source.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/data_source/fb_ads_firestore_data_source.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/mapper/mapper.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/repository/fb_ads_repository.dart';
import 'package:firebase/firebase.dart';

class FbAdsRepositoryImpl implements FbAdsRepository {
  FbAdsRepositoryImpl({
    required this.cloudFunctionDataSource,
    required this.firestoreController,
    required this.firestoreDataSource,
    required this.fbAdMapper,
    required this.fbPageInfoMapper,
    required this.searchTermMapper,
  });

  final FbAdsCloudFunctionDataSource cloudFunctionDataSource;
  final FbFirestoreController firestoreController;
  final FbAdsFirestoreDataSource firestoreDataSource;
  final FbAdMapper fbAdMapper;
  final FbPageInfoMapper fbPageInfoMapper;
  final SearchTermMapper searchTermMapper;

  @override
  Future<String> triggerScrape({
    required String searchTerms,
    String adType = 'ALL',
  }) => cloudFunctionDataSource.triggerScrape(
    searchTerms: searchTerms,
    adType: adType,
  );

  @override
  Stream<SearchTermEntity?> watchSearchTerm(String termId) =>
      firestoreDataSource
          .streamSearchTerm(termId)
          .map((m) => m == null ? null : searchTermMapper.map(m));

  @override
  Stream<List<SearchTermEntity>> watchSearchTerms() => firestoreDataSource
      .streamSearchTermsWithIds()
      .map((list) => list.map<SearchTermEntity>(searchTermMapper.map).toList());

  @override
  Future<List<FbAdEntity>> getAdsForTerm(
    String termId, {
    int? limit,
    String? startAfterDocId,
  }) async {
    final models = await firestoreDataSource.getAdsForTerm(
      termId,
      limit: limit,
      startAfterDocId: startAfterDocId,
    );
    return models.map((m) => fbAdMapper.to(m)).toList();
  }

  @override
  Future<FbPageInfoEntity?> getPageInfo({required String pageId}) async {
    final raw = await cloudFunctionDataSource.getPageInfo(pageId: pageId);
    if (raw == null) return null;
    return fbPageInfoMapper.map(raw);
  }
}
