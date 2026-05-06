import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/l10n/l10n.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/bloc.dart';
import 'package:global_ops/src/widget/widget.dart';

class ListContentWidget extends StatefulWidget {
  const ListContentWidget({super.key, required this.state});

  final AdPanelsLoadedState state;

  @override
  State<ListContentWidget> createState() => _ListContentWidgetState();
}

class _ListContentWidgetState extends State<ListContentWidget> {
  late final ScrollController _scrollController;

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
          if (widget.state.isRefreshing)
            DSLoadingWidget(size: context.space(factor: 5))
          else if (widget.state.isFilteredEmpty &&
              widget.state.hasActiveFilters)
            InfoCardWidget(
              icon: Icons.search_off,
              iconColor: context.colorPalette.neutral.grey1,
              title: context.localizations.adPanelNoResultTitle,
              description:
                  context.localizations.adPanelNoPanelFoundWithinRadiusFilter,
              action: context.localizations.adPanelDisableLocationBasedSearch,
              actionIcon: Icons.location_off_rounded,
              onPressed: () {
                context.read<ProximityAdPanelsBloc>().add(
                  const DisableLocationBasedSearchEvent(),
                );
              },
            )
          else if (panelObjectNumbers.isEmpty)
            InfoCardWidget(
              icon: Icons.inbox_outlined,
              iconColor: context.colorPalette.neutral.grey1,
              title: context.localizations.adPanelEmptyTitle,
              description:
                  context.localizations.adPanelNoPanelFoundWithinRadius,
              action: context.localizations.adPanelDisableLocationBasedSearch,
              actionIcon: Icons.location_off_rounded,
              onPressed: () {
                context.read<ProximityAdPanelsBloc>().add(
                  const DisableLocationBasedSearchEvent(),
                );
              },
            )
          else
            SafeArea(
              child: context.isMobile
                  ? _buildListView(context, panelObjectNumbers, panelsMap)
                  : _buildGridView(context, panelObjectNumbers, panelsMap),
            ),
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
    return AdPanelWidget(
      adPanels: adPanels,
      isDetailAvailable: widget.state.isAdPanelDetailEnabled,
    );
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
