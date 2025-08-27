import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class PaginatedAdPanelsScreen extends StatelessWidget {
  const PaginatedAdPanelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaginatedAdPanelsBloc>(
      create: (context) {
        return appServiceLocator.get<PaginatedAdPanelsBloc>()
          ..add(const LoadAdPanelsEvent());
      },
      child: BlocBuilder<PaginatedAdPanelsBloc, PaginatedAdPanelsState>(
        builder: (context, state) {
          return _ViewStateBuilderWidget(
            state: state,
            location: const LocationEntity(
              latitude: 52.3676,
              longitude: 4.9041,
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
      case final AdPanelsLoadedState state:
        return ContentWidget(
          state: state,
          location: location,
          isLoading: state.isRefreshing,
        );
    }
  }
}
