import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/bloc/bloc.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/widget/error_content_widget.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/widget/feature_flag_list_widget.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/widget/header_widget.dart';
import 'package:global_ops/src/feature/feature_toggle/presentation/screen/widget/loading_content_widget.dart';

class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FeatureToggleBloc, FeatureToggleState>(
      builder: (context, state) {
        switch (state) {
          case final FeatureToggleInitialState _:
          case final FeatureToggleLoadingState _:
            return const LoadingContentWidget();
          case final FeatureToggleErrorState state:
            return ErrorContentWidget(
              message: state.message,
              onRefresh: () {
                context.bloc.add(const ResetFFEvent());
              },
            );
          case final FeatureToggleLoadedState state:
            return Align(
              alignment: Alignment.topCenter,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: context.getFormCardWidth(constraints),
                      minHeight: constraints.maxHeight,
                    ),
                    child: Column(
                      children: [
                        const HeaderWidget(),
                        Expanded(
                          child: FeatureFlagsListWidget(
                            featureFlags: state.filteredFeatureFlags,
                            isGridVisible: state.isGridView,
                            searchQuery: state.searchQuery,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
        }
      },
    );
  }
}

extension on BuildContext {
  double getFormCardWidth(BoxConstraints constraints) {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return constraints.maxWidth;
      case DSDeviceWidthResolution.s:
        return constraints.maxWidth;
      case DSDeviceWidthResolution.m:
        return constraints.maxWidth * 0.8;
      case DSDeviceWidthResolution.l:
        return constraints.maxWidth * 0.7;
      case DSDeviceWidthResolution.xl:
        return constraints.maxWidth * 0.5;
    }
  }
}
