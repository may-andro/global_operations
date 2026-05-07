import 'package:fb_add_scrapper/src/route/module_route.dart';

class AdsScraperModuleRoute extends ModuleRoute {
  const AdsScraperModuleRoute._(String name, String path)
    : super(name: name, path: path);

  /// Main search-terms list screen (landing screen).
  static const AdsScraperModuleRoute adsSearch = AdsScraperModuleRoute._(
    'adsSearch',
    '/ads-search',
  );

  /// Ad detail screen.
  static const AdsScraperModuleRoute adDetail = AdsScraperModuleRoute._(
    'adDetail',
    '/ad-detail',
  );

  /// Ads list for a specific search term.
  static const AdsScraperModuleRoute termAdsList = AdsScraperModuleRoute._(
    'termAdsList',
    '/term-ads/:termId',
  );
}
