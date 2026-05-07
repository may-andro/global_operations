import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/widget/widget.dart';
import 'package:fb_add_scrapper/src/module_injector/app_module_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsSearchScreen extends StatelessWidget {
  const AdsSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AdsSearchBloc>(
      create: (_) =>
          appServiceLocator.get<AdsSearchBloc>()
            ..add(const LoadAdsSearchEvent()),
      child: BlocBuilder<AdsSearchBloc, AdsSearchState>(
        builder: (context, state) {
          return _ViewStateBuilderWidget(state: state);
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// State dispatcher — identical pattern to PaginatedAdPanelsScreen
// ---------------------------------------------------------------------------

class _ViewStateBuilderWidget extends StatelessWidget {
  const _ViewStateBuilderWidget({required this.state});

  final AdsSearchState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorPalette.background.primary.color,
      body: switch (state) {
        AdsSearchInitialState() ||
        AdsSearchLoadingState() => const LoadingContentWidget(),
        AdsSearchErrorState(:final message) => ErrorContentWidget(
          message: message,
        ),
        AdsSearchLoadedState() => ContentWidget(
          state: state as AdsSearchLoadedState,
        ),
      },
    );
  }
}
