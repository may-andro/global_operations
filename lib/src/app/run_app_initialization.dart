import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:global_ops/src/app/global_app.dart';
import 'package:global_ops/src/app/splash_app.dart';
import 'package:global_ops/src/feature/authentication/authentication.dart';
import 'package:global_ops/src/feature/locale/locale.dart';
import 'package:global_ops/src/module_injector/module_configurators.dart';
import 'package:global_ops/src/route/route.dart';
import 'package:global_ops/src/utility/app_bloc_observer.dart';
import 'package:log_reporter/log_reporter.dart';
import 'package:module_injector/module_injector.dart';
import 'package:tracking/tracking.dart';

Future<void> runAppWithInitialization() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle());

  final buildConfig = BuildConfig(
    buildEnvironment: BuildEnvironment.buildEnvironment,
  );
  final moduleConfigurators = getModuleConfigurators(buildConfig);

  FlutterNativeSplash.remove();

  runApp(
    SplashApp(
      buildConfig: buildConfig,
      moduleConfigurators: moduleConfigurators,
      onInitializationSuccessful: runMainApp,
    ),
  );
}

void runMainApp(DesignSystem designSystem) {
  final serviceLocator = ModuleInjectorController().serviceLocator;

  final appLocale = serviceLocator.get<AppLocale>();
  _sendAppStartEvent(appLocale);
  Bloc.observer = serviceLocator.get<AppBlocObserver>();

  runApp(
    LocaleListenerWidget(
      appLocale: appLocale,
      builder: (context, appLocale) {
        return GlobalApp(
          appLocale: appLocale,
          buildConfig: serviceLocator.get<BuildConfig>(),
          designSystem: designSystem,
          routeConfigurator: _routeConfigurator,
        );
      },
    ),
  );
}

RouteConfigurator get _routeConfigurator {
  final serviceLocator = ModuleInjectorController().serviceLocator;
  final moduleRouteConfigurator = serviceLocator.get<ModuleRouteController>();
  final navigationObservers = [
    serviceLocator.get<FirebaseAnalyticsObserver>(),
    serviceLocator.get<RouteNavigationObserver>(),
    serviceLocator.get<FocusClearingRouteObserver>(),
    routeObserver,
  ];
  final getUserProfileStreamUseCase = serviceLocator
      .get<GetUserProfileStreamUseCase>();
  final authNotifier = AuthNotifier(getUserProfileStreamUseCase);
  final routeConfigurator = RouteConfigurator(
    moduleRouteConfigurator.registeredModuleRouteConfigurator,
    navigationObservers,
    authNotifier,
  );
  return routeConfigurator;
}

void _sendAppStartEvent(AppLocale appLocale) {
  final serviceLocator = ModuleInjectorController().serviceLocator;

  final logReporter = serviceLocator.get<LogReporter>();
  logReporter.debug(
    'Project is setup in locale: ${appLocale.locale}',
    tag: 'runAppWithInitialization',
  );

  final trackingReporter = serviceLocator.get<TrackingReporter>();
  trackingReporter.sendTrackingEvent(AppInitializationFinishedTracking());
}
