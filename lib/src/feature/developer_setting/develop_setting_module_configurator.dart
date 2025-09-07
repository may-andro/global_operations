import 'package:global_ops/src/feature/developer_setting/presentation/presentation.dart';
import 'package:global_ops/src/route/route.dart';
import 'package:module_injector/module_injector.dart';

class DevelopSettingModuleConfigurator implements ModuleConfigurator {
  DevelopSettingModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {
    serviceLocator.get<ModuleRouteController>().register(
      DeveloperSettingModuleRouteConfigurator(),
    );
  }

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {}
}
