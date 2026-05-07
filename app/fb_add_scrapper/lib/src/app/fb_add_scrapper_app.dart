import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:fb_add_scrapper/l10n/l10n.dart';
import 'package:fb_add_scrapper/src/feature/locale/locale.dart';
import 'package:fb_add_scrapper/src/route/route.dart';

class FbAddScrapperApp extends StatelessWidget {
  const FbAddScrapperApp({
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
      title: 'FB Add Scrapper',
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
