import 'package:global_ops/src/feature/location/data/data.dart';
import 'package:global_ops/src/feature/location/domain/domain.dart';
import 'package:global_ops/src/feature/location/presentation/location_listener/bloc/bloc.dart';
import 'package:module_injector/module_injector.dart';

class LocationModuleConfigurator implements ModuleConfigurator {
  LocationModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerSingleton<LocationBasedSearchCache>(
      () => LocationBasedSearchCache(),
    );
    serviceLocator.registerSingleton<LocationRepository>(
      () => LocationRepositoryImpl(serviceLocator.get()),
    );

    serviceLocator.registerFactory<GetCurrentLocationUseCase>(
      () => GetCurrentLocationUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<TrackLocationUseCase>(
      () => TrackLocationUseCase(serviceLocator.get(), serviceLocator.get()),
    );
    serviceLocator.registerFactory<IsLocationBasedSearchEnabledUseCase>(
      () => IsLocationBasedSearchEnabledUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<IsLocationBasedSearchEnabledStreamUseCase>(
      () => IsLocationBasedSearchEnabledStreamUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<UpdateLocationBasedSearchEnabledUseCase>(
      () => UpdateLocationBasedSearchEnabledUseCase(serviceLocator.get()),
    );

    serviceLocator.registerFactory<LocationListenerBloc>(
      () => LocationListenerBloc(serviceLocator.get()),
    );
  }
}
