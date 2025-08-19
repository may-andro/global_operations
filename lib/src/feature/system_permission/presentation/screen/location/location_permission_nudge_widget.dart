import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/system_permission/domain/domain.dart';
import 'package:global_ops/src/feature/system_permission/presentation/screen/location/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';
import 'package:global_ops/src/widget/widget.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationPermissionNudgeWidget extends StatefulWidget {
  const LocationPermissionNudgeWidget({super.key, required this.child});

  final Widget child;

  @override
  State<LocationPermissionNudgeWidget> createState() =>
      _LocationPermissionNudgeWidgetState();
}

class _LocationPermissionNudgeWidgetState
    extends State<LocationPermissionNudgeWidget>
    with WidgetsBindingObserver {
  late final LocationPermissionBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _bloc = appServiceLocator.get<LocationPermissionBloc>();
    _bloc.add(const PermissionCheckRequestedEvent());
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
      _bloc.add(const PermissionCheckRequestedEvent());
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<LocationPermissionBloc, LocationPermissionState>(
        listenWhen: (prev, curr) =>
            curr is LocationPermissionStatusChangedState,
        listener: (context, state) {},
        builder: (context, state) {
          if (state is LocationPermissionStatusChangedState) {
            switch (state.status) {
              case PermissionStatusEntity.granted:
                return widget.child;
              case PermissionStatusEntity.permanentlyDenied:
                return InfoCardWidget(
                  icon: Icons.lock,
                  iconColor: context.colorPalette.semantic.error,
                  title: context
                      .localizations
                      .locationPermissionPermanentlyDeniedTitle,
                  description: context
                      .localizations
                      .locationPermissionPermanentlyDeniedDescription,
                  action: context.localizations.locationPermissionOpenSettings,
                  actionIcon: Icons.settings,
                  onPressed: openAppSettings,
                );
              case PermissionStatusEntity.denied:
                return InfoCardWidget(
                  icon: Icons.location_off,
                  iconColor: context.colorPalette.semantic.warning,
                  title: context.localizations.locationPermissionDeniedTitle,
                  description:
                      context.localizations.locationPermissionDeniedDescription,
                  action: context.localizations.locationPermissionAllow,
                  actionIcon: Icons.location_on,
                  onPressed: () => context.read<LocationPermissionBloc>().add(
                    const PermissionRequestEvent(),
                  ),
                );
              case PermissionStatusEntity.restricted:
                return InfoCardWidget(
                  icon: Icons.warning_amber_rounded,
                  iconColor: context.colorPalette.semantic.warning,
                  title:
                      context.localizations.locationPermissionRestrictedTitle,
                  description: context
                      .localizations
                      .locationPermissionRestrictedDescription,
                );
              case PermissionStatusEntity.limited:
                return InfoCardWidget(
                  icon: Icons.location_searching,
                  iconColor: context.colorPalette.semantic.info,
                  title: context.localizations.locationPermissionLimitedTitle,
                  description: context
                      .localizations
                      .locationPermissionLimitedDescription,
                );
              case PermissionStatusEntity.provisional:
                return InfoCardWidget(
                  icon: Icons.info_outline,
                  iconColor: context.colorPalette.semantic.info,
                  title:
                      context.localizations.locationPermissionProvisionalTitle,
                  description: context
                      .localizations
                      .locationPermissionProvisionalDescription,
                );
            }
          }
          if (state is LocationPermissionFailureState) {
            return Center(
              child: DSTextWidget(
                context.localizations.locationPermissionFailure,
                color: context.colorPalette.background.onPrimary,
                style: context.typography.bodyMedium,
              ),
            );
          }
          return Center(child: DSLoadingWidget(size: context.space(factor: 5)));
        },
      ),
    );
  }
}
