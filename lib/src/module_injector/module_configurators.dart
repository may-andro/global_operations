import 'package:cache/cache.dart';
import 'package:core/core.dart';
import 'package:error_reporter/error_reporter.dart';
import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/ad_panel.dart';
import 'package:global_ops/src/feature/authentication/authentication.dart';
import 'package:global_ops/src/feature/developer_setting/developer_setting.dart';
import 'package:global_ops/src/feature/feature_toggle/feature_toggle.dart';
import 'package:global_ops/src/feature/file_picker/file_picker.dart';
import 'package:global_ops/src/feature/home/home.dart';
import 'package:global_ops/src/feature/locale/locale.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:global_ops/src/feature/setting/setting.dart';
import 'package:global_ops/src/feature/system_permission/system_permission.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';
import 'package:global_ops/src/route/route.dart';
import 'package:global_ops/src/utility/utility_module_configurator.dart';
import 'package:log_reporter/log_reporter.dart';
import 'package:module_injector/module_injector.dart';
import 'package:remote/remote.dart';
import 'package:tracking/tracking.dart';
import 'package:use_case/use_case.dart';

List<ModuleConfigurator> getModuleConfigurators(BuildConfig buildConfig) => [
  AppModuleConfigurator(buildConfig),
  FirebaseModuleConfigurator(buildConfig.buildEnvironment.isFirebaseEnabled),
  TrackingModuleConfigurator(buildConfig.buildEnvironment.isFirebaseEnabled),
  LogReporterModuleConfigurator(),
  UtilityModuleConfigurator(),
  RouteModuleConfigurator(),
  UseCaseModuleConfigurator(),
  ErrorReporterModuleConfigurator(
    buildConfig.buildEnvironment.isFirebaseEnabled,
  ),
  const CacheModuleConfigurator(),
  RemoteModuleConfigurator(
    buildConfig.buildEnvironment.isRemoteLoggingEnabled,
    '',
  ),
  LocaleModuleConfigurator(),
  FilePickerModuleConfigurator(),
  SystemPermissionModuleConfigurator(),
  LocationModuleConfigurator(),
  FeatureToggleModuleConfigurator(),
  AuthenticationModuleConfigurator(),
  SettingModuleConfigurator(),
  DevelopSettingModuleConfigurator(),
  HomeModuleConfigurator(),
  AdPanelModuleConfigurator(),
];
