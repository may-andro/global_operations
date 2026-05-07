import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/fb_page_info_model.dart';
import 'package:firebase/firebase.dart';

/// Calls Facebook Ads data via Firebase Cloud Functions.
///
/// The access token lives exclusively in Firebase Secret Manager on the server
/// and is never sent to or stored on the device.
class FbAdsCloudFunctionDataSource {
  FbAdsCloudFunctionDataSource({
    required FbFunctionController functionController,
  }) : _functions = functionController;

  final FbFunctionController _functions;

  /// Triggers the [searchAds] Cloud Function to scrape up to 1000 ads into
  /// Firestore. Returns the [termId] immediately.
  Future<String> triggerScrape({
    required String searchTerms,
    String adType = 'ALL',
  }) async {
    final raw = await _functions.callFunction(
      'searchAds',
      parameters: {'searchTerms': searchTerms, 'adType': adType},
    );
    final data = Map<String, dynamic>.from(raw as Map);
    return data['termId'] as String;
  }

  /// Fetches public page info via the [getPageInfo] Cloud Function.
  /// Returns `null` when the page is not found or permissions are insufficient.
  Future<FbPageInfoModel?> getPageInfo({required String pageId}) async {
    final raw = await _functions.callFunction(
      'getPageInfo',
      parameters: {'pageId': pageId},
    );

    if (raw == null) return null;
    final data = Map<String, dynamic>.from(raw as Map);
    return FbPageInfoModel.fromJson(data);
  }
}
