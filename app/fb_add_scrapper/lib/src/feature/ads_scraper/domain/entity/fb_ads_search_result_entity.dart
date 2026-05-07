import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/fb_ad_entity.dart';

/// Represents a paginated page of results from a Facebook Ads Library search.
class FbAdsSearchResultEntity {
  const FbAdsSearchResultEntity({
    required this.ads,
    this.nextCursor,
    this.hasNextPage = false,
  });

  final List<FbAdEntity> ads;

  /// Cursor to pass as `after` for the next page.
  final String? nextCursor;

  final bool hasNextPage;
}

