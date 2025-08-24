import 'package:global_ops/src/route/route.dart';

class AdPanelModuleRoute extends ModuleRoute {
  const AdPanelModuleRoute._(String name, String path)
    : super(name: name, path: path);

  static const AdPanelModuleRoute adPanels = AdPanelModuleRoute._(
    'adPanels',
    '/ad_panels',
  );

  static const AdPanelModuleRoute adPanel = AdPanelModuleRoute._(
    'adPanel',
    '/ad_panel',
  );

  static const AdPanelModuleRoute searchAdPanels = AdPanelModuleRoute._(
    'search_ad_panel',
    '/search_ad_panel',
  );
}
