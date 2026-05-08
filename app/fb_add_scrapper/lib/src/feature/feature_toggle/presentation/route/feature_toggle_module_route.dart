import 'package:fb_add_scrapper/src/route/route.dart';

class FeatureToggleModuleRoute extends ModuleRoute {
  const FeatureToggleModuleRoute._(String name, String path)
    : super(name: name, path: path);

  static const FeatureToggleModuleRoute featureToggle =
      FeatureToggleModuleRoute._('featureToggle', '/feature_toggle');
}
