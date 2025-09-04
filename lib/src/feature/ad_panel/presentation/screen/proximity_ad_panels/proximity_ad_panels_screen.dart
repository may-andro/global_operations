import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:global_ops/src/feature/system_permission/system_permission.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class ProximityAdPanelsScreen extends StatelessWidget {
  const ProximityAdPanelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocationPermissionNudgeWidget(
      child: LocationListenerWidget(
        builder: (context, location) {
          return BlocProvider<ProximityAdPanelsBloc>(
            create: (context) =>
                appServiceLocator.get<ProximityAdPanelsBloc>()
                  ..add(LoadAdPanelsEvent(location)),
            child: _LocationAwareBuilder(location: location),
          );
        },
      ),
    );
  }
}

class _LocationAwareBuilder extends StatefulWidget {
  const _LocationAwareBuilder({required this.location});

  final LocationEntity location;

  @override
  State<_LocationAwareBuilder> createState() => _LocationAwareBuilderState();
}

class _LocationAwareBuilderState extends State<_LocationAwareBuilder> {
  LocationEntity? _lastLocation;

  @override
  void didUpdateWidget(_LocationAwareBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if location has changed
    if (_lastLocation != null &&
        (widget.location.latitude != _lastLocation!.latitude ||
            widget.location.longitude != _lastLocation!.longitude)) {
      // Location changed, trigger background update
      context.read<ProximityAdPanelsBloc>().add(
        UpdateLocationEvent(widget.location),
      );
    }
    _lastLocation = widget.location;
  }

  @override
  Widget build(BuildContext context) {
    _lastLocation ??= widget.location;

    return BlocBuilder<ProximityAdPanelsBloc, ProximityAdPanelsState>(
      builder: (context, state) {
        return _ViewStateBuilderWidget(state: state, location: widget.location);
      },
    );
  }
}

class _ViewStateBuilderWidget extends StatelessWidget {
  const _ViewStateBuilderWidget({required this.state, required this.location});

  final ProximityAdPanelsState state;
  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case final AdPanelsInitialState _:
      case final AdPanelsLoadingState _:
        return const LoadingContentWidget();
      case final AdPanelsErrorState state:
        return ErrorContentWidget(
          message: state.message,
          onRefresh: () {
            context.read<ProximityAdPanelsBloc>().add(
              const RetryLoadAdPanelsEvent(),
            );
          },
        );
      case final AdPanelsLoadedState state:
        return ContentWidget(state: state, location: location);
    }
  }
}
