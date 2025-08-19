import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
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
        return _ContentWidget(state: state, location: location);
      case final AdPanelsListLoadingState state:
        return _ContentWidget(
          state: state.previousState,
          location: location,
          isLoading: true,
        );
    }
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({
    required this.state,
    required this.location,
    this.isLoading = false,
  });

  final AdPanelsLoadedState state;
  final LocationEntity location;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilterSectionWidget(isEnabled: !isLoading),
        Expanded(
          child: _ViewTypeContentWidget(
            state: state,
            location: location,
            isLoading: isLoading,
          ),
        ),
      ],
    );
  }
}

class _ViewTypeContentWidget extends StatelessWidget {
  const _ViewTypeContentWidget({
    required this.state,
    required this.location,
    this.isLoading = false,
  });

  final AdPanelsLoadedState state;
  final LocationEntity location;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final viewType = state.viewType;
    return Stack(
      children: [
        if (viewType == AdPanelViewType.map) ...[
          MapContentWidget(
            location: location,
            adPanelsMap: state.filteredAdPanelsMap,
            isLoading: isLoading,
            circleRadius: state.radiusInKm * 1000,
          ),
        ] else ...[
          ListContentWidget(state: state, isLoading: isLoading),
        ],
        Positioned(
          left: 0,
          right: 0,
          bottom: context.space(factor: 3),
          child: Center(
            child: ViewTypeToggleButtonWidget(
              onToggle: (newViewType) {
                context.read<ProximityAdPanelsBloc>().add(
                  SetAdPanelsViewTypeEvent(newViewType),
                );
              },
              viewType: viewType,
              isVisible: !isLoading,
            ),
          ),
        ),
      ],
    );
  }
}
