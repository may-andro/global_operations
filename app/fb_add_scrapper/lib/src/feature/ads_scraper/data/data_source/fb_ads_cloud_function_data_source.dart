import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/fb_ads_search_result_model.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/fb_page_info_model.dart';
import 'package:firebase/firebase.dart';

/// Calls Facebook Ads data via Firebase Cloud Functions.
///
/// The access token lives exclusively in Firebase Secret Manager on the server
/// and is never sent to or stored on the device.
class FbAdsCloudFunctionDataSource {
  FbAdsCloudFunctionDataSource({required FbFunctionController functionController})
      : _functions = functionController;

  final FbFunctionController _functions;

  /// Searches the Facebook Ads Library via the [searchAds] Cloud Function.
  Future<FbAdsSearchResultModel> searchAds({
    required List<String> countries,
    String searchTerms = '',
    String adType = 'ALL',
    String? pageId,
    String? afterCursor,
    int limit = 50,
  }) async {
    final data = await _functions.callFunction(
      'searchAds',
      parameters: {
        'countries': countries,
        'adType': adType,
        'limit': limit,
        if (searchTerms.isNotEmpty) 'searchTerms': searchTerms,
        if (pageId != null) 'pageId': pageId,
        if (afterCursor != null) 'afterCursor': afterCursor,
      },
    ) as Map<String, dynamic>?;

    if (data == null) return const FbAdsSearchResultModel(ads: []);
    return FbAdsSearchResultModel.fromJson(data);
  }

  /// Fetches public page info via the [getPageInfo] Cloud Function.
  /// Returns `null` when the page is not found or permissions are insufficient.
  Future<FbPageInfoModel?> getPageInfo({required String pageId}) async {
    try {
      final data = await _functions.callFunction(
        'getPageInfo',
        parameters: {'pageId': pageId},
      ) as Map<String, dynamic>?;

      if (data == null) return null;
      return FbPageInfoModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}

