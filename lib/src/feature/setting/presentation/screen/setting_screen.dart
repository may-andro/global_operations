import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
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
      child: BlocBuilder<SettingBloc, SettingState>(
        builder: (context, state) {
          switch (state) {
            case SettingInitialState():
            case SettingLoadingState():
              return Center(
                child: DSLoadingWidget(size: context.space(factor: 5)),
              );
            case final SettingLoadedState state:
              return ContentWidget(state: state);
            case SettingErrorState(:final message):
              return Center(child: Text(message));
          }
        },
      ),
    );
  }
}
