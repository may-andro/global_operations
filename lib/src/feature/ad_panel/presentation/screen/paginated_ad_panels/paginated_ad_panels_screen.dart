import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:global_ops/src/feature/system_permission/system_permission.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class PaginatedAdPanelsScreen extends StatelessWidget {
  const PaginatedAdPanelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LocationPermissionNudgeWidget(
      child: LocationListenerWidget(
        builder: (context, location) {
          return BlocProvider<PaginatedAdPanelsBloc>(
            create: (context) {
              return appServiceLocator.get<PaginatedAdPanelsBloc>()
                ..add(const LoadAdPanelsEvent());
            },
            child: BlocBuilder<PaginatedAdPanelsBloc, PaginatedAdPanelsState>(
              builder: (context, state) {
                return _ViewStateBuilderWidget(
                  state: state,
                  location: location,
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ViewStateBuilderWidget extends StatelessWidget {
  const _ViewStateBuilderWidget({required this.state, required this.location});

  final PaginatedAdPanelsState state;
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
            context.read<PaginatedAdPanelsBloc>().add(
              const RetryLoadAdPanelsEvent(),
            );
          },
        );
      case final AdPanelsEmptyState _:
        return EmptyContentWidget(
          onRefresh: () {
            context.read<PaginatedAdPanelsBloc>().add(
              const LoadAdPanelsEvent(),
            );
          },
        );
      case final AdPanelsLoadedState state:
        return _ContentWidget(state: state, location: location);
    }
  }
}

class _ContentWidget extends StatelessWidget {
  const _ContentWidget({required this.state, required this.location});

  final AdPanelsLoadedState state;
  final LocationEntity location;

  @override
  Widget build(BuildContext context) {
    final viewType = state.viewType;
    return Column(
      children: [
        const FilterSectionWidget(),
        Expanded(
          child: Stack(
            children: [
              if (viewType.isMapType) ...[
                MapContentWidget(
                  location: location,
                  adPanelsMap: state.filteredAdPanelsMap,
                  isLoading: false,
                ),
              ] else ...[
                ListContentWidget(state: state),
              ],
              Positioned(
                right: 0,
                left: 0,
                bottom: context.space(factor: 3),
                child: Center(
                  child: ViewTypeToggleButtonWidget(
                    onToggle: (newViewType) {
                      context.read<PaginatedAdPanelsBloc>().add(
                        SetAdPanelsViewTypeEvent(newViewType),
                      );
                    },
                    viewType: viewType,
                    isVisible: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
