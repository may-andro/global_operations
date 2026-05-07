import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/model.dart';
import 'package:firebase/firebase.dart';

/// Scrapes the **public** Facebook Ads Library via a Firebase Cloud Function.
///
/// The Cloud Function (`searchFbAds`) runs server-side with a proper
/// cookie jar and browser-like headers — bypassing the restrictions that
/// block direct mobile requests to facebook.com.
///
/// Deploy the function from: tool/firebase/fb_ads_scraper/
class FbAdsWebScraperDataSource {
  FbAdsWebScraperDataSource({required FbFunctionController functionController})
    : _functionController = functionController;

  final FbFunctionController _functionController;

  /// Calls the `searchFbAds` Cloud Function.
  Future<FbAdsResponseModel> searchAds({
    required String query,
    String country = 'US',
    String adType = 'all',
    int offset = 0,
    int count = 30,
  }) async {
    final raw = await _functionController.callFunction(
      'searchFbAds',
      parameters: {
        'query': query,
        'country': country,
        'adType': adType,
        'offset': offset,
        'count': count,
      },
    ) as Map<String, dynamic>;

    final rawAds = raw['ads'] as List<dynamic>? ?? [];
    final ads = rawAds.map((e) => _mapToModel(e as Map<String, dynamic>)).toList();
    final hasNextPage = raw['hasNextPage'] as bool? ?? false;

    return FbAdsResponseModel(ads: ads, hasNextPage: hasNextPage);
  }

  FbAdModel _mapToModel(Map<String, dynamic> r) => FbAdModel(
    id: (r['id'] as String?) ?? '',
    pageName: r['pageName'] as String?,
    pageId: r['pageId'] as String?,
    adCreativeBody: r['adCreativeBody'] as String?,
    adCreativeLinkTitle: r['adCreativeLinkTitle'] as String?,
    adCreativeLinkUrl: r['adCreativeLinkUrl'] as String?,
    adCreativeLinkCaption: r['adCreativeLinkCaption'] as String?,
    adSnapshotUrl: r['adSnapshotUrl'] as String?,
    adDeliveryStartTime: r['adDeliveryStartTime'] as String?,
    adDeliveryStopTime: r['adDeliveryStopTime'] as String?,
    publisherPlatforms: (r['publisherPlatforms'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    currency: r['currency'] as String?,
    fundingEntity: r['fundingEntity'] as String?,
  );
}

