import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/route/route.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/widget/widget.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';
import 'package:global_ops/src/route/route.dart';

class FeatureToggleScreen extends StatelessWidget {
  const FeatureToggleScreen({super.key});

  static void navigate(BuildContext context) {
    context.push(FeatureToggleModuleRoute.featureToggle.path);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          appServiceLocator.get<FeatureToggleBloc>()..add(const LoadFFEvent()),
      child: BlocBuilder<FeatureToggleBloc, FeatureToggleState>(
        builder: (context, state) {
          return RouteObserverWidget(
            onResume: () => context.bloc.add(TrackScreenVisibleEvent()),
            child: Scaffold(
              backgroundColor: context.colorPalette.background.primary.color,
              appBar: DSAppBarWidget(
                height: DSAppBarWidget.getHeight(context),
                onBackClicked: context.pop,
                actions: [
                  if (state is FeatureToggleLoadedState &&
                      state.filteredFeatureFlags.isNotEmpty)
                    IconButton(
                      icon: Icon(
                        state.isGridView ? Icons.view_list : Icons.grid_view,
                      ),
                      onPressed: () =>
                          context.bloc.add(UpdateListViewTypeEvent()),
                    ),
                  IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: () => context.bloc.add(const ResetFFEvent()),
                  ),
                ],
              ),
              body: const ContentWidget(),
            ),
          );
        },
      ),
    );
  }
}
