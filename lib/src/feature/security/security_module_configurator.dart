import 'package:global_ops/src/feature/security/data/data.dart';
import 'package:global_ops/src/feature/security/domain/domain.dart';
import 'package:global_ops/src/feature/security/presentation/widget/date_time/bloc/bloc.dart';
import 'package:global_ops/src/feature/security/presentation/widget/tempered_device/bloc/bloc.dart';
import 'package:module_injector/module_injector.dart';

class SecurityModuleConfigurator implements ModuleConfigurator {
  SecurityModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void preDependenciesSetup(ServiceLocator serviceLocator) {}

  @override
  void registerDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerSingleton<DateTimeSecurityRepository>(
      () => DateTimeSecurityRepositoryImpl(
        serviceLocator.get(),
        serviceLocator.get(),
      ),
    );

    serviceLocator.registerSingleton<TemperedDeviceRepository>(
      () => TemperedDeviceRepositoryImpl(),
    );

    serviceLocator.registerFactory<DateTimeValidationUseCase>(
      () => DateTimeValidationUseCase(serviceLocator.get()),
    );

    serviceLocator.registerFactory<TemperedDeviceValidationUseCase>(
      () => TemperedDeviceValidationUseCase(
        serviceLocator.get(),
        serviceLocator.get(),
      ),
    );

    serviceLocator.registerFactory<DateTimeValidationBloc>(
      () => DateTimeValidationBloc(serviceLocator.get()),
    );

    serviceLocator.registerFactory<TemperedDeviceBloc>(
      () => TemperedDeviceBloc(serviceLocator.get()),
    );
  }
}
