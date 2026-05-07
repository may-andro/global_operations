import 'package:fb_add_scrapper/src/feature/locale/presentation/route/locale_module_route.dart';
import 'package:fb_add_scrapper/src/feature/locale/presentation/screen/screen.dart';
import 'package:fb_add_scrapper/src/route/route.dart';

class LocaleModuleRouteConfigurator implements ModuleRouteConfigurator {
  @override
  List<GoRoute> get routes {
    return [
      GoRoute(
        name: LocaleModuleRoute.localeSelection.name,
        path: LocaleModuleRoute.localeSelection.path,
        builder: (context, state) => const LocaleSelectionScreen(),
      ),
    ];
  }

  @override
  List<ModuleRoute> get publicRoutes => [LocaleModuleRoute.localeSelection];
}
