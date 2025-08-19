import 'package:global_ops/src/route/route.dart';

class AuthenticationModuleRoute extends ModuleRoute {
  const AuthenticationModuleRoute._(String name, String path)
    : super(name: name, path: path);

  static const AuthenticationModuleRoute auth = AuthenticationModuleRoute._(
    'auth',
    '/',
  );

  static const AuthenticationModuleRoute login = AuthenticationModuleRoute._(
    'login',
    '/login',
  );

  static const AuthenticationModuleRoute deleteAccount =
      AuthenticationModuleRoute._('deleteAccount', '/delete-account');

  static const AuthenticationModuleRoute resetPassword =
      AuthenticationModuleRoute._('resetPassword', '/reset-password');

  static const AuthenticationModuleRoute updatePassword =
      AuthenticationModuleRoute._('updatePassword', '/update-password');
}
