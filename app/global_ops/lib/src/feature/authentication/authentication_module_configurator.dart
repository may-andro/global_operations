import 'package:global_ops/src/feature/authentication/data/repository/repository.dart';
import 'package:global_ops/src/feature/authentication/domain/domain.dart';
import 'package:global_ops/src/feature/authentication/presentation/presentation.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/delete_account/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/login/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/logout/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/reset_password/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/update_password/bloc/bloc.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/user_account_setting/bloc/bloc.dart';
import 'package:global_ops/src/route/route.dart';
import 'package:module_injector/module_injector.dart';

class AuthenticationModuleConfigurator implements ModuleConfigurator {
  AuthenticationModuleConfigurator();

  @override
  void postDependenciesSetup(ServiceLocator serviceLocator) {
    serviceLocator.get<ModuleRouteController>().register(
      AuthenticationModuleRouteConfigurator(),
    );
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
    serviceLocator.registerSingleton<AuthRepository>(
      () => AuthRepositoryImpl(serviceLocator.get()),
    );
    serviceLocator.registerSingleton<UserRepository>(
      () => UserRepositoryImpl(serviceLocator.get()),
    );
  }

  void _registerDomainDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<DeleteAccountUseCase>(
      () => DeleteAccountUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<GetUserProfileStreamUseCase>(
      () => GetUserProfileStreamUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<GetUserProfileUseCase>(
      () => GetUserProfileUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<LoginUseCase>(
      () => LoginUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<LogoutUseCase>(
      () => LogoutUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<UpdatePasswordUseCase>(
      () => UpdatePasswordUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<ResetPasswordRequestUseCase>(
      () => ResetPasswordRequestUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<VerifyResetPasswordCodeUseCase>(
      () => VerifyResetPasswordCodeUseCase(serviceLocator.get()),
    );
    serviceLocator.registerFactory<ConfirmPasswordResetUseCase>(
      () => ConfirmPasswordResetUseCase(serviceLocator.get()),
    );
  }

  void _registerPresentationDependencies(ServiceLocator serviceLocator) {
    serviceLocator.registerFactory<LoginBloc>(
      () => LoginBloc(serviceLocator.get()),
    );
    serviceLocator.registerFactory<LogoutBloc>(
      () => LogoutBloc(serviceLocator.get()),
    );
    serviceLocator.registerFactory<DeleteAccountBloc>(
      () => DeleteAccountBloc(serviceLocator.get(), serviceLocator.get()),
    );
    serviceLocator.registerFactory<UserAccountSettingBloc>(
      () => UserAccountSettingBloc(serviceLocator.get()),
    );
    serviceLocator.registerFactory<ResetPasswordBloc>(
      () => ResetPasswordBloc(serviceLocator.get()),
    );
    serviceLocator.registerFactory<UpdatePasswordBloc>(
      () => UpdatePasswordBloc(serviceLocator.get(), serviceLocator.get()),
    );
  }
}
