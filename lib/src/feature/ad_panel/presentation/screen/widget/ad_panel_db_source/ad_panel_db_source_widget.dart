import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/widget/ad_panel_db_source/bloc/bloc.dart';
import 'package:global_ops/src/module_injector/app_module_configurator.dart';

class AdPanelDbSourceWidget extends StatelessWidget {
  const AdPanelDbSourceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          appServiceLocator.get<AdPanelDbSourceBloc>()
            ..add(const LoadDbSourcesEvent()),
      child: BlocBuilder<AdPanelDbSourceBloc, AdPanelDbSourceState>(
        builder: (context, state) {
          if (state is AdPanelDbSourceLoadingState) {
            return Center(
              child: DSLoadingWidget(size: context.space(factor: 2)),
            );
          } else if (state is AdPanelDbSourceErrorState) {
            return DSTextWidget(
              state.message,
              color: context.colorPalette.semantic.error,
              style: context.typography.bodyMedium,
            );
          } else if (state is AdPanelDbSourceLoadedState) {
            return DsCardWidget(
              backgroundColor: context.colorPalette.invertedBackground.primary,
              radius: context.dimen.radiusLevel2,
              elevation: context.dimen.elevationLevel1,
              margin: EdgeInsets.symmetric(
                horizontal: context.space(factor: 2),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: context.space(factor: context.isDesktop ? 2 : 3),
                  vertical: context.space(factor: 2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: state.selectedSource,
                        //padding: EdgeInsets.zero,
                        isDense: true,
                        items: state.sources
                            .map(
                              (source) => DropdownMenuItem<String>(
                                value: source,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.data_object_rounded,
                                      color: context
                                          .colorPalette
                                          .invertedBackground
                                          .onPrimary
                                          .color,
                                    ),
                                    const DSHorizontalSpacerWidget(1),
                                    Expanded(
                                      child: DSTextWidget(
                                        source,
                                        style: context.typography.bodyLarge,
                                        color: context
                                            .colorPalette
                                            .invertedBackground
                                            .onPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }
                          context.bloc.add(SelectDbSourceEvent(value));
                        },
                        isExpanded: true,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: context
                              .colorPalette
                              .invertedBackground
                              .onPrimary
                              .color,
                        ),
                        style: context.typography.bodyLarge.textStyle,
                        dropdownColor: context
                            .colorPalette
                            .invertedBackground
                            .primary
                            .color,
                      ),
                    ),
                    DSTextWidget(
                      'Select your data source. Use Staging for testing or previewing changes. Choose Production for live, reliable data.',
                      color: context.colorPalette.invertedBackground.onPrimary,
                      style: context.typography.bodySmall,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
