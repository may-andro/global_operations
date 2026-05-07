import 'package:design_system/design_system.dart';
import 'package:error_reporter/error_reporter.dart';
import 'package:fb_add_scrapper/src/error_reporter/blacklist_exception.dart';
import 'package:fb_add_scrapper/src/feature/developer_setting/presentation/route/route.dart';
import 'package:fb_add_scrapper/src/feature/feature_toggle/feature_toggle.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DeveloperMenuScreen extends StatelessWidget {
  const DeveloperMenuScreen({super.key});

  static void navigate(BuildContext context) {
    context.push(DeveloperSettingModuleRoute.developerMenu.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DSAppBarWidget(height: DSAppBarWidget.getHeight(context)),
      body: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.getFormCardWidth(constraints),
                minHeight: constraints.maxHeight,
              ),
              child: CustomScrollView(
                scrollBehavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                shrinkWrap: true,
                slivers: [
                  if (context.isDesktop) ...[
                    const SliverToBoxAdapter(child: DSVerticalSpacerWidget(2)),
                  ],

                  SliverToBoxAdapter(
                    child: _ItemWidget(
                      title: 'Open Feature Flag',
                      subtitle:
                          'Feature flags control access to experimental and advanced features. Tap to view and manage which features are currently enabled.',
                      onTap: () => FeatureToggleScreen.navigate(context),
                    ),
                  ),
                  const SliverToBoxAdapter(child: DSVerticalSpacerWidget(2)),
                  const SliverToBoxAdapter(child: DSVerticalSpacerWidget(2)),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.space(factor: 2),
                      ),
                      child: DSTextWidget(
                        'Crashlytics',
                        color: context.colorPalette.background.onPrimary,
                        style: context.typography.labelLarge,
                      ),
                    ),
                  ),
                  const SliverToBoxAdapter(child: DSVerticalSpacerWidget(2)),
                  SliverToBoxAdapter(
                    child: _ItemWidget(
                      title: 'Simulate Dart crash',
                      subtitle:
                          'Force a fatal crash to verify Crashlytics integration.',
                      onTap: () => throw _FatalException('Force crash'),
                    ),
                  ),
                  const SliverToBoxAdapter(child: DSVerticalSpacerWidget(2)),
                  SliverToBoxAdapter(
                    child: _ItemWidget(
                      title: 'Simulate blacklisted exception',
                      subtitle:
                          'Blacklisted exceptions are ignored by Crashlytics.',
                      onTap: () {
                        throw _BlacklistException('Blacklisted exception');
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DsCardWidget(
      backgroundColor: context.colorPalette.invertedBackground.primary,
      radius: context.dimen.radiusLevel2,
      elevation: context.dimen.elevationLevel1,
      margin: EdgeInsets.symmetric(horizontal: context.space(factor: 2)),
      child: Padding(
        padding: EdgeInsets.all(context.space()),
        child: ListTile(
          onTap: onTap,
          title: DSTextWidget(
            title,
            color: context.colorPalette.invertedBackground.onPrimary,
            style: context.typography.bodyLarge,
          ),
          subtitle: DSTextWidget(
            subtitle,
            color: context.colorPalette.invertedBackground.onPrimary,
            style: context.typography.bodySmall,
          ),
        ),
      ),
    );
  }
}

class _FatalException implements FatalException {
  _FatalException(this.message);

  final String message;

  @override
  String toString() => message;
}

class _BlacklistException implements BlacklistException {
  _BlacklistException(this.message);

  final String message;

  @override
  String toString() => message;
}

extension on BuildContext {
  double getFormCardWidth(BoxConstraints constraints) {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return constraints.maxWidth;
      case DSDeviceWidthResolution.s:
        return constraints.maxWidth;
      case DSDeviceWidthResolution.m:
        return constraints.maxWidth * 0.8;
      case DSDeviceWidthResolution.l:
        return constraints.maxWidth * 0.7;
      case DSDeviceWidthResolution.xl:
        return constraints.maxWidth * 0.5;
    }
  }
}
