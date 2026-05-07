import 'package:fb_add_scrapper/src/feature/ads_scraper/data/model/fb_ad_model.dart';

/// Data model for a paginated page of results from the Facebook Ads Library API.
///
/// Example raw response:
/// ```json
/// {
///   "data": [ {...}, {...} ],
///   "paging": {
///     "cursors": { "before": "...", "after": "..." },
///     "next": "https://..."
///   }
/// }
/// ```
class FbAdsSearchResultModel {
  const FbAdsSearchResultModel({
    required this.ads,
    this.nextCursor,
    this.hasNextPage = false,
  });

  factory FbAdsSearchResultModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as List<dynamic>? ?? [];
    final ads = rawData
        .map((e) => FbAdModel.fromJson(e as Map<String, dynamic>))
        .toList();

    final paging = json['paging'] as Map<String, dynamic>?;
    final cursors = paging?['cursors'] as Map<String, dynamic>?;
    final nextCursor = cursors?['after'] as String?;
    final hasNextPage = paging?['next'] != null;

    return FbAdsSearchResultModel(
      ads: ads,
      nextCursor: nextCursor,
      hasNextPage: hasNextPage,
    );
  }

  final List<FbAdModel> ads;

  /// Cursor to pass as `after` for the next page.
  final String? nextCursor;

  final bool hasNextPage;
}

