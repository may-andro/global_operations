import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';

import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/widget/filter_section_widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/widget/list_content_widget.dart';
import 'package:global_ops/src/feature/location/location.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    super.key,
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
        Positioned.fill(
          child: IndexedStack(
            index: viewType.positionIndex,
            children: [
              MapContentWidget(
                location: location,
                adPanelsMap: state.filteredAdPanelsMap,
                isLoading: isLoading,
              ),
              ListContentWidget(state: state, isLoading: isLoading),
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
                context.read<PaginatedAdPanelsBloc>().add(
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
