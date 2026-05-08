import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/l10n/l10n.dart';
import 'package:fb_add_scrapper/src/feature/authentication/authentication.dart';
import 'package:fb_add_scrapper/src/feature/setting/presentation/screen/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/setting/presentation/screen/widget/footer_widget.dart';
import 'package:fb_add_scrapper/src/feature/setting/presentation/screen/widget/language_card_widget.dart';
import 'package:fb_add_scrapper/src/feature/setting/presentation/screen/widget/section_title_widget.dart';
import 'package:flutter/material.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key, required this.state});

  final SettingLoadedState state;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: context.getFormCardWidth(constraints),
                minHeight: constraints.maxHeight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(factor: 2),
                  vertical: context.space(factor: context.isDesktop ? 2 : 0),
                ),
                child: IntrinsicHeight(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SectionTitleWidget(
                        title: context
                            .localizations
                            .settingUserManagementSectionTitle,
                      ),
                      const UserAccountSettingScreen(),
                      const DSVerticalSpacerWidget(2),
                      SectionTitleWidget(
                        title:
                            context.localizations.settingLanguageSectionTitle,
                      ),
                      const LanguageCardWidget(),
                      const Spacer(),
                      const DSVerticalSpacerWidget(3),
                      const Align(child: FooterWidget()),
                      const DSVerticalSpacerWidget(2),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
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
