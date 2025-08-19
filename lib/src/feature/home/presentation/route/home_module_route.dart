import 'package:global_ops/src/route/route.dart';

class HomeModuleRoute extends ModuleRoute {
  const HomeModuleRoute._(String name, String path)
    : super(name: name, path: path);

  static const HomeModuleRoute home = HomeModuleRoute._('home', '/home');
}
