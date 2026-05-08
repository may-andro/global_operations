import 'package:cache/cache.dart';
import 'package:core/core.dart';
import 'package:error_reporter/error_reporter.dart';
import 'package:fb_add_scrapper/firebase/firebase_options.dart';
import 'package:fb_add_scrapper/src/feature/authentication/authentication.dart';
import 'package:fb_add_scrapper/src/feature/developer_setting/developer_setting.dart';
import 'package:fb_add_scrapper/src/feature/feature_toggle/feature_toggle.dart';
import 'package:fb_add_scrapper/src/feature/file_picker/file_picker.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/ads_scraper.dart';
import 'package:fb_add_scrapper/src/feature/home/home.dart';
import 'package:fb_add_scrapper/src/feature/locale/locale.dart';
import 'package:fb_add_scrapper/src/feature/security/security.dart';
import 'package:fb_add_scrapper/src/feature/setting/setting.dart';
import 'package:fb_add_scrapper/src/feature/system_permission/system_permission.dart';
import 'package:fb_add_scrapper/src/module_injector/app_module_configurator.dart';
import 'package:fb_add_scrapper/src/route/route.dart';
import 'package:fb_add_scrapper/src/utility/utility_module_configurator.dart';
import 'package:firebase/firebase.dart';
import 'package:log_reporter/log_reporter.dart';
import 'package:module_injector/module_injector.dart';
import 'package:tracking/tracking.dart';
import 'package:use_case/use_case.dart';

List<ModuleConfigurator> getModuleConfigurators(BuildConfig buildConfig) => [
  AppModuleConfigurator(buildConfig),
  FirebaseModuleConfigurator(
    buildConfig.buildEnvironment.isFirebaseEnabled,
    firebaseOptions: DefaultFirebaseOptions.currentPlatform,
  ),
  TrackingModuleConfigurator(buildConfig.buildEnvironment.isFirebaseEnabled),
  LogReporterModuleConfigurator(),
  UtilityModuleConfigurator(),
  RouteModuleConfigurator(),
  UseCaseModuleConfigurator(),
  ErrorReporterModuleConfigurator(
    buildConfig.buildEnvironment.isFirebaseEnabled,
  ),
  const CacheModuleConfigurator(),
  LocaleModuleConfigurator(),
  FilePickerModuleConfigurator(),
  SystemPermissionModuleConfigurator(),
  FeatureToggleModuleConfigurator(),
  SecurityModuleConfigurator(),
  AuthenticationModuleConfigurator(),
  SettingModuleConfigurator(),
  DevelopSettingModuleConfigurator(),
  HomeModuleConfigurator(),
  AdsScraperModuleConfigurator(),
];
