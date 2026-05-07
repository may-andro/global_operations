import 'package:fb_add_scrapper/src/feature/system_permission/data/mapper/mapper.dart';
import 'package:fb_add_scrapper/src/feature/system_permission/data/repository/permission_repository_impl.dart';
import 'package:fb_add_scrapper/src/feature/system_permission/domain/domain.dart';
import 'package:module_injector/module_injector.dart';

class SystemPermissionModuleConfigurator implements ModuleConfigurator {
  SystemPermissionModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<PermissionMapper>(() => PermissionMapper());
    serviceLocator.registerFactory<PermissionStatusMapper>(
      () => PermissionStatusMapper(),
    );

    serviceLocator.registerSingleton<PermissionRepository>(
      () => PermissionRepositoryImpl(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ),
    );

    serviceLocator.registerFactory<GetPermissionStatusUseCase>(
      () => GetPermissionStatusUseCase(serviceLocator.get()),
    );

    serviceLocator.registerFactory<RequestPermissionUseCase>(
      () => RequestPermissionUseCase(serviceLocator.get()),
    );
  }
}
