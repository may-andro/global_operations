import 'package:global_ops/src/feature/authentication/presentation/route/authentication_module_route.dart';
import 'package:global_ops/src/feature/authentication/presentation/screen/screen.dart';
import 'package:global_ops/src/route/route.dart';

class AuthenticationModuleRouteConfigurator implements ModuleRouteConfigurator {
  @override
  List<GoRoute> get routes {
    return [
      GoRoute(
        name: AuthenticationModuleRoute.auth.name,
        path: AuthenticationModuleRoute.auth.path,
        pageBuilder: (context, state) {
          return state.getCustomTransitionPage(const AuthScreen());
        },
      ),
      GoRoute(
        name: AuthenticationModuleRoute.login.name,
        path: AuthenticationModuleRoute.login.path,
        pageBuilder: (context, state) {
          return state.getCustomTransitionPage(const LoginScreen());
        },
      ),
      GoRoute(
        name: AuthenticationModuleRoute.resetPassword.name,
        path: AuthenticationModuleRoute.resetPassword.path,
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      GoRoute(
        name: AuthenticationModuleRoute.deleteAccount.name,
        path: AuthenticationModuleRoute.deleteAccount.path,
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        name: AuthenticationModuleRoute.updatePassword.name,
        path: AuthenticationModuleRoute.updatePassword.path,
        builder: (context, state) => const UpdatePasswordScreen(),
      ),
    ];
  }

  @override
  List<ModuleRoute> get publicRoutes => [
    AuthenticationModuleRoute.resetPassword,
  ];
}
