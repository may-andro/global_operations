import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/widget/filter_section_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/widget/list_content_widget.dart';
import 'package:global_ops/src/feature/location/location.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key, required this.state, required this.location});

  final AdPanelsLoadedState state;
  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const FilterSectionWidget(),
        Expanded(
          child: _ViewTypeContentWidget(state: state, location: location),
        ),
      ],
    );
  }
}

class _ViewTypeContentWidget extends StatelessWidget {
  const _ViewTypeContentWidget({required this.state, required this.location});

  final AdPanelsLoadedState state;
  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    final viewType = state.viewType;
    return Stack(
      children: [
        Positioned.fill(
          child: IndexedStack(
            index: viewType.positionIndex,
            children: [
              if (state.isGoogleMapViewAvailable)
                MapContentWidget(
                  location: location,
                  adPanelsMap: state.filteredAdPanelsMap,
                  isLoading: state.isRefreshing,
                  isDetailAvailable: state.isAdPanelDetailEnabled,
                  circleRadius: state.radiusInKm * 1000,
                )
              else
                const SizedBox.shrink(),
              ListContentWidget(state: state),
            ],
          ),
        ),
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
              isVisible: !state.isRefreshing && state.isGoogleMapViewAvailable,
            ),
          ),
        ),
      ],
    );
  }
}
