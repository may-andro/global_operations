import 'package:global_ops/src/feature/setting/presentation/screen/bloc/bloc.dart';
import 'package:module_injector/module_injector.dart';

class SettingModuleConfigurator implements ModuleConfigurator {
  SettingModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<SettingBloc>(
      () => SettingBloc(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ),
    );
  }
}
