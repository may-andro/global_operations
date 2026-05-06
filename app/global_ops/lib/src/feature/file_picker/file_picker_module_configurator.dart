import 'dart:async';

import 'package:global_ops/src/feature/file_picker/domain/domain.dart';
import 'package:module_injector/module_injector.dart';

class FilePickerModuleConfigurator implements ModuleConfigurator {
  @override
  FutureOr<void> postDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  FutureOr<void> preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  FutureOr<void> registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory(() => FilePickerUseCase());

    serviceLocator.registerFactory(() => FileOpenerUseCase());

    serviceLocator.registerFactory(() => ImagePickerUseCase());
  }
}
