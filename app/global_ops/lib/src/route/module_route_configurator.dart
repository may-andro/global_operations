import 'package:global_ops/src/route/module_route.dart';
import 'package:go_router/go_router.dart';

abstract class ModuleRouteConfigurator {
  List<GoRoute> get routes;

  List<ModuleRoute> get publicRoutes;
}
