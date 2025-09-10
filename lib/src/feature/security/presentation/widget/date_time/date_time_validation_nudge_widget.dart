import 'package:design_system/design_system.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/developer_setting/developer_setting.dart';
import 'package:global_ops/src/feature/security/presentation/widget/date_time/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';
import 'package:global_ops/src/widget/info_card_widget.dart';

class DateTimeValidationNudgeWidget extends StatefulWidget {
  const DateTimeValidationNudgeWidget({super.key, required this.child});

  final Widget child;

  @override
  State<DateTimeValidationNudgeWidget> createState() =>
      _DateTimeValidationNudgeWidgetState();
}

class _DateTimeValidationNudgeWidgetState
    extends State<DateTimeValidationNudgeWidget>
    with WidgetsBindingObserver {
  late final DateTimeValidationBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = appServiceLocator.get<DateTimeValidationBloc>();
    _bloc.add(const RequestDateTimeValidationEvent());
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
      _bloc.add(const RequestDateTimeValidationEvent());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _bloc,
      child: BlocBuilder<DateTimeValidationBloc, DateTimeValidationState>(
        builder: (context, state) {
          switch (state) {
            case final DateTimeValidationInitialState _:
            case final DateTimeValidationProgressState _:
              return Center(
                child: DSLoadingWidget(size: context.space(factor: 5)),
              );
            case final DateTimeValidationValidState _:
              return widget.child;
            case DateTimeValidationInvalidState _:
              return InfoCardWidget(
                icon: Icons.access_time_filled_rounded,
                iconColor: context.colorPalette.semantic.warning,
                title: 'Incorrect Device Time',
                description:
                    'Your device clock appears incorrect. Please enable automatic date & time in the device settings.',
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
