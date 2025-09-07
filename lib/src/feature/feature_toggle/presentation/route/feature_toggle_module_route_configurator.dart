import 'package:global_ops/src/feature/feature_toggle/presentation/route/feature_toggle_module_route.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/feature_toggle_screen.dart';
import 'package:global_ops/src/route/route.dart';

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
