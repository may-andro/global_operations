import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/ad_panel.dart';
import 'package:global_ops/src/feature/developer_setting/developer_setting.dart';
import 'package:global_ops/src/feature/home/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/feature/home/presentation/screen/widget/widget.dart';
import 'package:global_ops/src/feature/security/security.dart';
import 'package:global_ops/src/feature/setting/setting.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => appServiceLocator.get<HomeBloc>(),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          final content = _ContentWidget(
            key: const ValueKey('home_content'),
            selectedIndex: state.selectedIndex,
          );

          return Scaffold(
            backgroundColor: context.colorPalette.background.primary.color,
            appBar: DSAppBarWidget(
              height: DSAppBarWidget.getHeight(context),
              onLogoClicked: () {
                if (state.isDeveloperModeEnabled) {
                  DeveloperMenuScreen.navigate(context);
                  return;
                }
                context.read<HomeBloc>().add(const LogoTappedEvent());
              },
            ),
            body: Row(
              children: [
                if (context.isDesktop)
                  WebNavigationBarWidget(
                    selectedIndex: state.selectedIndex,
                    onDestinationSelected: (index) {
                      context.read<HomeBloc>().add(TabChangedEvent(index));
                    },
                  ),
                Expanded(child: content),
              ],
            ),
            bottomNavigationBar: BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                return MobileNavigationBarWidget(
                  selectedIndex: state.selectedIndex,
                  onItemTapped: (index) {
                    return context.read<HomeBloc>().add(TabChangedEvent(index));
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ContentWidget extends StatelessWidget {
  _ContentWidget({required this.selectedIndex, super.key});

  final int selectedIndex;

  final _pages = <Widget>[const AdPanelsScreen(), const SettingScreen()];

  @override
  Widget build(BuildContext context) {
    return TemperedDeviceNudgeWidget(
      child: DateTimeValidationNudgeWidget(
        child: IndexedStack(index: selectedIndex, children: _pages),
      ),
    );
    return IndexedStack(index: selectedIndex, children: _pages);
  }
}
