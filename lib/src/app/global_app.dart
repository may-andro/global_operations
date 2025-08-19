import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/locale/locale.dart';
import 'package:global_ops/src/route/route.dart';

class GlobalApp extends StatelessWidget {
  const GlobalApp({
    required this.buildConfig,
    required this.designSystem,
    required this.routeConfigurator,
    required this.appLocale,
    super.key,
  });

  final AppLocale appLocale;
  final BuildConfig buildConfig;
  final DesignSystem designSystem;
  final RouteConfigurator routeConfigurator;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Global Operations',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appLocale.locale,
      debugShowCheckedModeBanner:
          buildConfig.buildEnvironment.debugShowCheckedModeBanner,
      builder: (context, child) {
        return DSThemeBuilderWidget(
          brightness: context.platformBrightness,
          designSystem: designSystem,
          child: SystemLocaleListenerWidget(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
      routerConfig: routeConfigurator.router,
    );
  }
}
