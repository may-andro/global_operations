import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/route/ads_scraper_module_route.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_detail/ads_detail_screen.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/ads_search_screen.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/ads_list_screen.dart';
import 'package:fb_add_scrapper/src/route/module_route.dart';
import 'package:fb_add_scrapper/src/route/module_route_configurator.dart';
import 'package:go_router/go_router.dart';

class AdsScraperModuleRouteConfigurator implements ModuleRouteConfigurator {
  @override
  List<GoRoute> get routes {
    return [
      GoRoute(
        name: AdsScraperModuleRoute.adsSearch.name,
        path: AdsScraperModuleRoute.adsSearch.path,
        builder: (context, state) => const AdsSearchScreen(),
      ),
      GoRoute(
        name: AdsScraperModuleRoute.adDetail.name,
        path: AdsScraperModuleRoute.adDetail.path,
        builder: (context, state) {
          final ad = state.extra as FbAdEntity;
          return AdDetailScreen(ad: ad);
        },
      ),
      GoRoute(
        name: AdsScraperModuleRoute.termAdsList.name,
        path: AdsScraperModuleRoute.termAdsList.path,
        builder: (context, state) {
          final termId = state.pathParameters['termId']!;
          return AdsListScreen(termId: termId);
        },
      ),
    ];
  }

  @override
  List<ModuleRoute> get publicRoutes => [];
}
