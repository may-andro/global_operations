import 'package:fb_add_scrapper/src/feature/feature_toggle/presentation/route/feature_toggle_module_route.dart';
import 'package:fb_add_scrapper/src/feature/feature_toggle/presentation/screen/feature_toggle_screen.dart';
import 'package:fb_add_scrapper/src/route/route.dart';

class FeatureToggleModuleRouteConfigurator implements ModuleRouteConfigurator {
  @override
  List<GoRoute> get routes {
    return [
      GoRoute(
        name: FeatureToggleModuleRoute.featureToggle.name,
        path: FeatureToggleModuleRoute.featureToggle.path,
        builder: (context, state) {
          return const FeatureToggleScreen();
        },
      ),
    ];
  }

  @override
  List<ModuleRoute> get publicRoutes => [];
}
