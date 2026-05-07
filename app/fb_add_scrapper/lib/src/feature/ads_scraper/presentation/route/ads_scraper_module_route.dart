import 'package:fb_add_scrapper/src/route/module_route.dart';

class AdsScraperModuleRoute extends ModuleRoute {
  const AdsScraperModuleRoute._(String name, String path)
    : super(name: name, path: path);

  static const AdsScraperModuleRoute adsSearch = AdsScraperModuleRoute._(
    'adsSearch',
    '/ads-search',
  );

  static const AdsScraperModuleRoute adDetail = AdsScraperModuleRoute._(
    'adDetail',
    '/ad-detail',
  );
}

