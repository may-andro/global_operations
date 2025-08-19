import 'package:global_ops/src/feature/home/presentation/presentation.dart';
import 'package:global_ops/src/feature/home/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/route/route.dart';
import 'package:module_injector/module_injector.dart';

class HomeModuleConfigurator implements ModuleConfigurator {
  HomeModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {
    serviceLocator.get<ModuleRouteController>().register(
      HomeModuleRouteConfigurator(),
    );
  }

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<HomeBloc>(() => HomeBloc());
  }
}
