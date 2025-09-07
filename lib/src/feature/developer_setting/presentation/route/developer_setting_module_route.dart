import 'package:global_ops/src/route/route.dart';

class DeveloperSettingModuleRoute extends ModuleRoute {
  const DeveloperSettingModuleRoute._(String name, String path)
    : super(name: name, path: path);

  static const DeveloperSettingModuleRoute developerMenu =
      DeveloperSettingModuleRoute._('developerMenu', '/developer-menu');
}
