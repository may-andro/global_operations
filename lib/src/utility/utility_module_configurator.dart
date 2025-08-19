import 'dart:async';

import 'package:global_ops/src/utility/app_bloc_observer.dart';
import 'package:global_ops/src/utility/log_use_case_interceptor.dart';
import 'package:log_reporter/log_reporter.dart';
import 'package:module_injector/module_injector.dart';

class UtilityModuleConfigurator implements ModuleConfigurator {
  UtilityModuleConfigurator();

  @override
  FutureOr<void> postDependenciesSetup(ServiceLocator serviceLocator) => null;

  @override
  FutureOr<void> preDependenciesSetup(ServiceLocator serviceLocator) => null;

  @override
  FutureOr<void> registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory(
      () => LogUseCaseInterceptor(serviceLocator.get<LogReporter>()),
    );

    serviceLocator.registerFactory(
      () => AppBlocObserver(serviceLocator.get<LogReporter>()),
    );
  }
}
