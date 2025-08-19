import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/widget/widget.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/paginated_ad_panels/bloc/bloc.dart';

class ListContentWidget extends StatefulWidget {
  const ListContentWidget({super.key, required this.state});

  final AdPanelsLoadedState state;

  @override
  State<ListContentWidget> createState() => _ListContentWidgetState();
}

class _ListContentWidgetState extends State<ListContentWidget> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && widget.state.hasMoreData && !widget.state.isLoadingMore) {
      context.read<PaginatedAdPanelsBloc>().add(const LoadMoreAdPanelsEvent());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9); // Load more when 90% scrolled
  }

  @override
  Widget build(BuildContext context) {
    final panelsMap = widget.state.filteredAdPanelsMap;
    final panelObjectNumbers = panelsMap.keys.toList();
    return RefreshIndicator(
      onRefresh: () async {
        context.read<PaginatedAdPanelsBloc>().add(const RefreshAdPanelsEvent());
      },
      child: Stack(
        children: [
          if (widget.state.isFilteredEmpty && widget.state.hasActiveFilters)
            NoResultFoundWidget(
              onRefresh: () {
                context.read<PaginatedAdPanelsBloc>().add(
                  const ClearAdPanelsFiltersEvent(),
                );
              },
            )
          else if (panelObjectNumbers.isEmpty)
            EmptyContentWidget(
              onRefresh: () {
                context.read<PaginatedAdPanelsBloc>().add(
                  const LoadAdPanelsEvent(),
                );
              },
            )
          else
            SafeArea(
              child: _ListWidget(
                panelsMap: panelsMap,
                panelObjectNumbers: panelObjectNumbers,
                scrollController: _scrollController,
                hasMoreData: widget.state.hasMoreData,
                isLoadingMore: widget.state.isLoadingMore,
              ),
            ),

          // Show refresh indicator overlay
          if (widget.state.isRefreshing) const LoadingContentWidget(),
        ],
      ),
    );
  }
}

class _ListWidget extends StatelessWidget {
  const _ListWidget({
    required this.panelsMap,
    required this.panelObjectNumbers,
    required this.scrollController,
    required this.hasMoreData,
    required this.isLoadingMore,
  });

  final Map<String, List<AdPanelEntity>> panelsMap;
  final List<String> panelObjectNumbers;
  final ScrollController scrollController;
  final bool hasMoreData;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.all(context.space(factor: 2)),
      itemCount: panelObjectNumbers.length + (hasMoreData ? 1 : 0),
      // +1 for loading indicator
      itemBuilder: (context, index) {
        // Show loading indicator at the bottom
        if (index == panelObjectNumbers.length) {
          return _LoadingMoreWidget(isLoading: isLoadingMore);
        }

        final key = panelObjectNumbers[index];
        final adPanels = panelsMap[key];
        if (adPanels == null || adPanels.isEmpty) {
          return const SizedBox.shrink();
        }
        return AdPanelWidget(adPanels: adPanels);
      },
    );
  }
}

class _LoadingMoreWidget extends StatelessWidget {
  const _LoadingMoreWidget({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.all(context.space(factor: 2)),
      child: Center(child: DSLoadingWidget(size: context.space(factor: 3))),
    );
  }
}
