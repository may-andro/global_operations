import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/route/ad_panel_module_route.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/screen.dart';
import 'package:global_ops/src/route/route.dart';

class AdPanelModuleRouteConfigurator implements ModuleRouteConfigurator {
  @override
  List<GoRoute> get routes {
    return [
      GoRoute(
        name: AdPanelModuleRoute.adPanel.name,
        path: AdPanelModuleRoute.adPanel.path,
        builder: (context, state) {
          final adPanels = state.extra as List<AdPanelEntity>?;
          return AdPanelScreen(adPanels: adPanels ?? const []);
        },
      ),
      GoRoute(
        name: AdPanelModuleRoute.searchAdPanels.name,
        path: AdPanelModuleRoute.searchAdPanels.path,
        builder: (context, state) => const SearchAdPanelsScreen(),
      ),
    ];
  }

  @override
  List<ModuleRoute> get publicRoutes => [];
}
