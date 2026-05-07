import 'package:dio/dio.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/model.dart';

/// Wraps all calls to the Facebook Ads Library Graph API.
///
/// Prerequisites:
/// 1. Create an app at https://developers.facebook.com/
/// 2. Request access to the Ads Library API at
///    https://www.facebook.com/ads/library/api/
/// 3. Generate a user access token with the `ads_read` permission.
class FbAdsApiDataSource {
  FbAdsApiDataSource({Dio? dio})
    : _dio = dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://graph.facebook.com/v19.0',
              connectTimeout: const Duration(seconds: 30),
              receiveTimeout: const Duration(seconds: 30),
              // Never throw on HTTP errors – we inspect the body ourselves.
              validateStatus: (_) => true,
            ),
          );

  final Dio _dio;

  // Fields requested from the Ads Library API per ad.
  // Note: `impressions`, `spend` and `ad_creative_link_url` are NOT available
  // via the public Ads Library API and will cause a 400 error.
  static const _adFields = [
    'id',
    'ad_creation_time',
    'ad_creative_bodies',
    'ad_creative_link_captions',
    'ad_creative_link_descriptions',
    'ad_creative_link_titles',
    'ad_delivery_start_time',
    'ad_delivery_stop_time',
    'ad_snapshot_url',
    'currency',
    'page_id',
    'page_name',
    'languages',
    'publisher_platforms',
  ];

  /// Searches the Facebook Ads Library.
  ///
  /// [accessToken] – a long-lived user token with `ads_read` permission.
  /// [searchTerms] – keyword query (pass empty string to get all ads for a page).
  /// [countries]   – ISO-3166 alpha-2 codes, e.g. `['US', 'GB']`. Required.
  /// [adType]      – `ALL`, `POLITICAL_AND_ISSUE_ADS`, or `HOUSING_ADS`.
  /// [afterCursor] – opaque pagination cursor from the previous response.
  /// [limit]       – results per page (max 100).
  Future<FbAdsResponseModel> searchAds({
    required String accessToken,
    required List<String> countries,
    String searchTerms = '',
    String adType = 'ALL',
    String? pageId,
    String? afterCursor,
    int limit = 50,
  }) async {
    final params = <String, dynamic>{
      'access_token': accessToken,
      'ad_type': adType,
      'fields': _adFields.join(','),
      'limit': limit,
      if (searchTerms.isNotEmpty) 'search_terms': searchTerms,
      if (pageId != null) 'search_page_ids': pageId,
      if (afterCursor != null) 'after': afterCursor,
    };

    // Graph API requires array params as ad_reached_countries[0]=US&[1]=GB
    for (var i = 0; i < countries.length; i++) {
      params['ad_reached_countries[$i]'] = countries[i];
    }

    Response<dynamic> response;
    try {
      response = await _dio.get<dynamic>('/ads_archive', queryParameters: params);
    } on DioException catch (e) {
      // ignore: avoid_print
      print('[FbAdsApiDataSource] Network error: ${e.message}');
      rethrow;
    }

    // ignore: avoid_print
    print('[FbAdsApiDataSource] HTTP ${response.statusCode} → ${response.data}');

    if ((response.statusCode ?? 0) >= 400) {
      final fbError = (response.data as Map<String, dynamic>?)?['error'];
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
        message: 'FB API ${response.statusCode}: $fbError',
      );
    }

    final data = response.data;
    if (data == null || data is! Map<String, dynamic>) {
      return const FbAdsResponseModel(ads: []);
    }
    return FbAdsResponseModel.fromJson(data);
  }
}

