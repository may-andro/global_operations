import 'dart:ui';

import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';

class ListContentWidget extends StatefulWidget {
  const ListContentWidget({
    super.key,
    required this.state,
    required this.isLoading,
  });

  final AdPanelsLoadedState state;
  final bool isLoading;

  @override
  State<ListContentWidget> createState() => _ListContentWidgetState();
}

class _ListContentWidgetState extends State<ListContentWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final panelsMap = widget.state.filteredAdPanelsMap;
    final panelObjectNumbers = panelsMap.keys.toList();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProximityAdPanelsBloc>().add(const RefreshAdPanelsEvent());
      },
      child: Stack(
        children: [
          if (widget.state.isFilteredEmpty && widget.state.hasActiveFilters)
            NoResultFoundWidget(
              onRefresh: () {
                context.read<ProximityAdPanelsBloc>().add(
                  const ClearAdPanelsFiltersEvent(),
                );
              },
            )
          else if (panelObjectNumbers.isEmpty)
            EmptyContentWidget(
              onRefresh: () {
                context.read<ProximityAdPanelsBloc>().add(
                  const RefreshAdPanelsEvent(),
                );
              },
            )
          else
            SafeArea(
              child: context.isDesktop
                  ? _buildGridView(context, panelObjectNumbers, panelsMap)
                  : _buildListView(context, panelObjectNumbers, panelsMap),
            ),

          AnimatedSwitcher(
            duration: 300.ms,
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            child: widget.state.isRefreshing || widget.isLoading
                ? ClipRect(
                    child: BackdropFilter(
                      key: const ValueKey('loading'),
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: ColoredBox(
                        color: context.colorPalette.background.primary.color
                            .withAlpha(20),
                        child: const LoadingContentWidget(),
                      ),
                    ),
                  )
                : const SizedBox.shrink(key: ValueKey('not_loading')),
          ),
          //if (widget.state.isRefreshing) const LoadingContentWidget(),
        ],
      ),
    );
  }

  /// Builds the grid view for desktop
  Widget _buildGridView(
    BuildContext context,
    List<String> panelObjectNumbers,
    Map<String, List<AdPanelEntity>> panelsMap,
  ) {
    return Padding(
      padding: EdgeInsets.all(context.space(factor: 2)),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.crossAxisCount,
          crossAxisSpacing: context.space(),
          mainAxisExtent: AdPanelWidget.getHeight(context),
        ),
        itemCount: panelObjectNumbers.length,
        itemBuilder: (context, index) {
          final key = panelObjectNumbers[index];
          return _buildPanelItem(key, panelsMap);
        },
      ),
    );
  }

  /// Builds the list view for mobile
  Widget _buildListView(
    BuildContext context,
    List<String> panelObjectNumbers,
    Map<String, List<AdPanelEntity>> panelsMap,
  ) {
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.all(context.space(factor: 2)),
      itemCount: panelObjectNumbers.length,
      itemBuilder: (context, index) {
        final key = panelObjectNumbers[index];
        return _buildPanelItem(key, panelsMap);
      },
    );
  }

  /// Builds a panel item widget
  Widget _buildPanelItem(
    String key,
    Map<String, List<AdPanelEntity>> panelsMap,
  ) {
    final adPanels = panelsMap[key];
    if (adPanels == null || adPanels.isEmpty) {
      return const SizedBox.shrink();
    }
    return AdPanelWidget(adPanels: adPanels);
  }
}

extension on BuildContext {
  int get crossAxisCount {
    switch (deviceWidth) {
      case DSDeviceWidthResolution.xs:
        return 1;
      case DSDeviceWidthResolution.s:
        return 1;
      case DSDeviceWidthResolution.m:
        return 2;
      case DSDeviceWidthResolution.l:
        return 3;
      case DSDeviceWidthResolution.xl:
        return 4;
    }
  }
}
