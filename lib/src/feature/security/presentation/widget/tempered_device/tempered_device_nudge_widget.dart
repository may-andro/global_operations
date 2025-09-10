import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/developer_setting/developer_setting.dart';
import 'package:global_ops/src/feature/security/presentation/widget/tempered_device/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';
import 'package:global_ops/src/widget/info_card_widget.dart';

class TemperedDeviceNudgeWidget extends StatefulWidget {
  const TemperedDeviceNudgeWidget({super.key, required this.child});

  final Widget child;

  @override
  State<TemperedDeviceNudgeWidget> createState() =>
      _TemperedDeviceNudgeWidgetState();
}

class _TemperedDeviceNudgeWidgetState extends State<TemperedDeviceNudgeWidget>
    with WidgetsBindingObserver {
  late final TemperedDeviceBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = appServiceLocator.get<TemperedDeviceBloc>();
    _bloc.add(const RequestTemperedDeviceEvent());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _bloc.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _bloc.add(const RequestTemperedDeviceEvent());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocBuilder<TemperedDeviceBloc, TemperedDeviceState>(
        builder: (context, state) {
          switch (state) {
            case final TemperedDeviceInitialState _:
            case final TemperedDeviceProgressState _:
              return Center(
                child: DSLoadingWidget(size: context.space(factor: 5)),
              );
            case final DeviceUntemperedState _:
              return widget.child;
            case DeviceTemperedState _:
              return InfoCardWidget(
                icon: Icons.safety_check_rounded,
                iconColor: context.colorPalette.semantic.error,
                title: 'Tempered Device',
                description:
                    'Your device appears to be compromised. For your security, please avoid using this app on a rooted or jailbroken device.',
                actionIcon: kDebugMode ? Icons.developer_mode_rounded : null,
                action: kDebugMode ? 'Open Developer Options' : null,
                onPressed: kDebugMode
                    ? () {
                        DeveloperMenuScreen.navigate(context);
                      }
                    : null,
              );
          }
        },
      ),
    );
  }
}
