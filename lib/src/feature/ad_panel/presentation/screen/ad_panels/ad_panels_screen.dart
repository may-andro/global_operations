import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/paginated_ad_panels_screen.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/proximity_ad_panels_screen.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class AdPanelsScreen extends StatelessWidget {
  const AdPanelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdPanelsBloc>(
      create: (context) =>
          appServiceLocator.get<AdPanelsBloc>()..add(LoadAdPanelsEvent()),
      child: BlocBuilder<AdPanelsBloc, AdPanelsState>(
        builder: (context, state) {
          switch (state) {
            case AdPanelsLoadingState():
            case AdPanelsInitialState():
              return const Center(child: CircularProgressIndicator());
            case AdPanelsLoadedState(:final isLocationBasedSearchEnabled):
              return isLocationBasedSearchEnabled
                  ? const ProximityAdPanelsScreen()
                  : const PaginatedAdPanelsScreen();
            case AdPanelsErrorState(:final message):
              return Center(child: Text(message));
            default:
              return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
