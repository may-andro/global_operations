import 'package:fb_add_scrapper/src/feature/developer_setting/presentation/route/developer_setting_module_route.dart';
import 'package:fb_add_scrapper/src/feature/developer_setting/presentation/screen/developer_menu/developer_menu_screen.dart';
import 'package:fb_add_scrapper/src/route/route.dart';

class DeveloperSettingModuleRouteConfigurator
    implements ModuleRouteConfigurator {
  @override
  List<GoRoute> get routes {
    return [
      GoRoute(
        name: DeveloperSettingModuleRoute.developerMenu.name,
        path: DeveloperSettingModuleRoute.developerMenu.path,
        builder: (context, state) {
          return const DeveloperMenuScreen();
        },
      ),
    ];
  }

  @override
  List<ModuleRoute> get publicRoutes => [];
}
