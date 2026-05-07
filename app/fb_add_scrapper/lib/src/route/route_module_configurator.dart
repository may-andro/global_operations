import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fb_add_scrapper/src/route/focus_clearing_route_observer.dart';
import 'package:fb_add_scrapper/src/route/module_route_controller.dart';
import 'package:fb_add_scrapper/src/route/route_navigation_observer.dart';
import 'package:log_reporter/log_reporter.dart';
import 'package:module_injector/module_injector.dart';

class RouteModuleConfigurator implements ModuleConfigurator {
  RouteModuleConfigurator();

  @override
  FutureOr<void> postDependenciesSetup(ServiceLocator serviceLocator) => null;

  @override
  FutureOr<void> preDependenciesSetup(ServiceLocator serviceLocator) => null;

  @override
  FutureOr<void> registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerSingleton(
      () => ModuleRouteController(serviceLocator.get<LogReporter>()),
    );

    serviceLocator.registerFactory(
      () => RouteNavigationObserver(serviceLocator.get<LogReporter>()),
    );

    serviceLocator.registerFactory(
      () => FocusClearingRouteObserver(FocusManager.instance),
    );
  }
}
