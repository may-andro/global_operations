import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/extension/l10n_extension.dart';
import 'package:global_ops/src/feature/authentication/authentication.dart';
import 'package:global_ops/src/feature/setting/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/feature/setting/presentation/screen/widget/widget.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          appServiceLocator.get<SettingBloc>()..add(LoadSettingsEvent()),
      child: Align(
        alignment: Alignment.topCenter,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: constraints.maxHeight,
                maxWidth: context.getFormCardWidth(constraints),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.space(factor: 2),
                    vertical: context.space(factor: context.isDesktop ? 2 : 0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                      const DSVerticalSpacerWidget(2),
                      SectionTitleWidget(
                        title: context
                            .localizations
                            .settingSearchCriteriaSectionTitle,
                      ),
                      const SearchCriteriaCardWidget(),
                      const DSVerticalSpacerWidget(3),
                      const FooterWidget(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
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
