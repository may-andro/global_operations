import 'package:core/core.dart';
import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/feature_toggle/data/cache/feature_flag_cache.dart';
import 'package:global_ops/src/feature/feature_toggle/data/mapper/mapper.dart';
import 'package:global_ops/src/feature/feature_toggle/data/repository/build_feature_flag_repository.dart';
import 'package:global_ops/src/feature/feature_toggle/data/repository/cached_feature_flag_repository.dart';
import 'package:global_ops/src/feature/feature_toggle/data/repository/remote_feature_flag_repository.dart';
import 'package:global_ops/src/feature/feature_toggle/domain/domain.dart';
import 'package:global_ops/src/feature/feature_toggle/domain/use_case/init_feature_flags_use_case.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/presentation.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/tracking/feature_toggle_tracking_delegate.dart';
import 'package:global_ops/src/route/route.dart';
import 'package:module_injector/module_injector.dart';

class FeatureToggleModuleConfigurator implements ModuleConfigurator {
  FeatureToggleModuleConfigurator();

  @override
  Future<void> postDependenciesSetup(ServiceLocator serviceLocator) async {
    serviceLocator.get<ModuleRouteController>().register(
      FeatureToggleModuleRouteConfigurator(),
    );
    await serviceLocator.get<FeatureFlagCache>().initializeDB();
    await serviceLocator.get<InitFeatureFlagsUseCase>().call();
  }

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    _registerDataDependencies(serviceLocator);
    _registerDomainDependencies(serviceLocator);
    _registerPresentationDependencies(serviceLocator);
  }

  void _registerDataDependencies(ServiceLocator serviceLocator) {
    // cache
    serviceLocator.registerSingleton<FeatureFlagCache>(
      () => FeatureFlagCache(),
    );

    // mapper
    serviceLocator.registerFactory<FeatureModelMapper>(
      () => FeatureModelMapper(),
    );
    serviceLocator.registerFactory<FeatureFlagMapper>(
      () => FeatureFlagMapper(),
    );

    // repository
    final remoteFeatureFlagRepository = RemoteFeatureFlagRepository(
      serviceLocator.get<FbRemoteConfigController>(),
    );
    final cachedFeatureFlagRepository = CachedFeatureFlagRepository(
      remoteFeatureFlagRepository,
      serviceLocator.get<FeatureFlagCache>(),
      FeatureFlagMapper(),
      FeatureModelMapper(),
    );
    serviceLocator.registerSingleton<FeatureFlagRepository>(
      () => BuildFeatureFlagRepository(
        serviceLocator.get<BuildConfig>(),
        cachedFeatureFlagRepository,
        remoteFeatureFlagRepository,
      ),
    );
  }

  void _registerDomainDependencies(ServiceLocator serviceLocator) {
    // use case
    serviceLocator.registerFactory(
      () => GetFeatureFlagsUseCase(serviceLocator.get<FeatureFlagRepository>()),
    );
    serviceLocator.registerFactory(
      () =>
          InitFeatureFlagsUseCase(serviceLocator.get<FeatureFlagRepository>()),
    );
    serviceLocator.registerFactory(
      () =>
          IsFeatureEnabledUseCase(serviceLocator.get<FeatureFlagRepository>()),
    );
    serviceLocator.registerFactory(
      () =>
          ResetFeatureFlagsUseCase(serviceLocator.get<FeatureFlagRepository>()),
    );
    serviceLocator.registerFactory(
      () =>
          UpdateFeatureFlagUseCase(serviceLocator.get<FeatureFlagRepository>()),
    );
  }

  void _registerPresentationDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<FeatureToggleTrackingDelegate>(
      () => FeatureToggleTrackingDelegate(serviceLocator.get()),
    );
    serviceLocator.registerFactory<FeatureToggleBloc>(
      () => FeatureToggleBloc(
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
        serviceLocator.get(),
      ),
    );
  }
}
