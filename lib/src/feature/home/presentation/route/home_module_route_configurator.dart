import 'package:global_ops/src/feature/home/presentation/route/home_module_route.dart';
import 'package:global_ops/src/feature/home/presentation/screen/home_screen.dart';
import 'package:global_ops/src/route/route.dart';

class HomeModuleRouteConfigurator implements ModuleRouteConfigurator {
  @override
  List<GoRoute> get routes {
    return [
      GoRoute(
        name: HomeModuleRoute.home.name,
        path: HomeModuleRoute.home.path,
        pageBuilder: (context, state) {
          return state.getCustomTransitionPage(const HomeScreen());
        },
      ),
    ];
  }

  @override
  List<ModuleRoute> get publicRoutes => [];
}
