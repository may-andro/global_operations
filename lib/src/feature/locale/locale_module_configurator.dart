import 'package:core/core.dart';
import 'package:global_ops/src/feature/locale/data/data.dart';
import 'package:global_ops/src/feature/locale/domain/domain.dart';
import 'package:global_ops/src/feature/locale/presentation/presentation.dart';
import 'package:global_ops/src/feature/locale/presentation/screen/locale_selection/bloc/bloc.dart';
import 'package:global_ops/src/feature/locale/presentation/tracking/tracking.dart';
import 'package:global_ops/src/route/module_route_controller.dart';
import 'package:module_injector/module_injector.dart';
import 'package:tracking/tracking.dart';

class LocaleModuleConfigurator implements ModuleConfigurator {
  LocaleModuleConfigurator();

  @override
  Future<void> postDependenciesSetup(ServiceLocator serviceLocator) async {
    final appLocale = serviceLocator.get<AppLocale>();
    final appLocaleEither = await serviceLocator.get<GetLocaleUseCase>().call();

    if (appLocaleEither.isRight) {
      final cachedAppLocale = appLocaleEither.right;
      if (appLocale != cachedAppLocale) {
        serviceLocator.get<UpdateLocaleUseCase>().call(cachedAppLocale);
      }
    }

    serviceLocator.get<ModuleRouteController>().register(
      LocaleModuleRouteConfigurator(),
    );
  }

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerSingleton(() => AppLocaleCache());

    serviceLocator.registerSingleton<LocaleRepository>(
      () => LocaleRepositoryImpl(
        serviceLocator.get<AppLocale>(),
        serviceLocator.get<AppLocaleCache>(),
      ),
    );

    serviceLocator.registerFactory(
      () => GetLocaleUseCase(serviceLocator.get<LocaleRepository>()),
    );
    serviceLocator.registerFactory(
      () => UpdateLocaleUseCase(serviceLocator.get<LocaleRepository>()),
    );
    serviceLocator.registerFactory(
      () => GetLocaleStreamUseCase(serviceLocator.get<LocaleRepository>()),
    );

    serviceLocator.registerFactory(
      () => LocaleTrackingDelegate(serviceLocator.get<TrackingReporter>()),
    );

    serviceLocator.registerFactory(
      () => LocaleSelectionBloc(
        serviceLocator.get<GetLocaleUseCase>(),
        serviceLocator.get<UpdateLocaleUseCase>(),
      ),
    );
  }
}
