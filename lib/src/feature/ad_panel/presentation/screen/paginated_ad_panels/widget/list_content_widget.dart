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
  late final ScrollController _scrollController;

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

  void _scrollToUpdatedItems(String objectNumber) {
    if (!_scrollController.hasClients) return;

    final panelObjectNumbers = widget.state.filteredAdPanelsMap.keys.toList();
    final targetIndex = panelObjectNumbers.indexOf(objectNumber);
    if (targetIndex == -1) return;

    // The list/grid has EdgeInsets.all(space(factor: 2)) padding around it.
    // That top-padding is paid ONCE, not per item.
    // AdPanelWidget.getHeight() already includes the card's bottom margin,
    // so itemHeight per slot = getHeight() with no extra spacing added.
    final topPadding = context.space(factor: 2);
    double targetOffset;

    if (context.isMobile) {
      final itemHeight = AdPanelWidget.getHeight(context);
      targetOffset = topPadding + targetIndex * itemHeight;
    } else {
      final crossAxisCount = context.crossAxisCount;
      final rowIndex = targetIndex ~/ crossAxisCount;
      // GridView has no mainAxisSpacing, so each row is exactly itemHeight tall.
      final itemHeight = AdPanelWidget.getHeight(context);
      targetOffset = topPadding + rowIndex * itemHeight;
    }

    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: 500.ms,
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final panelsMap = widget.state.filteredAdPanelsMap;
    final panelObjectNumbers = panelsMap.keys.toList();

    return BlocListener<PaginatedAdPanelsBloc, PaginatedAdPanelsState>(
      // Only scroll when the scroll-target changes to a new non-null value.
      // This prevents re-triggering the scroll on every LoadMore state update,
      // which preserves the existing objectNumberToScrollTo in copyWith.
      listenWhen: (previous, current) {
        if (current is! AdPanelsLoadedState) return false;
        final scrollTarget = current.objectNumberToScrollTo;
        if (scrollTarget == null || scrollTarget.isEmpty) return false;
        if (previous is! AdPanelsLoadedState) return true;
        return previous.objectNumberToScrollTo != scrollTarget;
      },
      listener: (context, state) {
        if (state is AdPanelsLoadedState && !state.isRefreshing) {
          // Wait a frame for the UI to rebuild after refresh
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.objectNumberToScrollTo case final String objectNumber) {
              _scrollToUpdatedItems(objectNumber);
            }
          });
        }
      },
      child: RefreshIndicator(
        onRefresh: () async {
          context.read<PaginatedAdPanelsBloc>().add(
            const RefreshAdPanelsEvent(),
          );
        },
        child: Stack(
          children: [
            if (widget.state.isRefreshing)
              DSLoadingWidget(size: context.space(factor: 5))
            else if (widget.state.isFilteredEmpty &&
                widget.state.hasActiveFilters)
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
                child: context.isMobile
                    ? _ListWidget(
                        panelsMap: panelsMap,
                        panelObjectNumbers: panelObjectNumbers,
                        scrollController: _scrollController,
                        hasMoreData: widget.state.hasMoreData,
                        isLoadingMore: widget.state.isLoadingMore,
                        isDetailAvailable: widget.state.isAdPanelDetailEnabled,
                      )
                    : _GridWidget(
                        panelsMap: panelsMap,
                        panelObjectNumbers: panelObjectNumbers,
                        scrollController: _scrollController,
                        hasMoreData: widget.state.hasMoreData,
                        isLoadingMore: widget.state.isLoadingMore,
                        isDetailAvailable: widget.state.isAdPanelDetailEnabled,
                      ),
              ),
          ],
        ),
      ),
    );
  }
}

class _GridWidget extends StatelessWidget {
  const _GridWidget({
    required this.panelsMap,
    required this.panelObjectNumbers,
    required this.scrollController,
    required this.hasMoreData,
    required this.isLoadingMore,
    required this.isDetailAvailable,
  });

  final Map<String, List<AdPanelEntity>> panelsMap;
  final List<String> panelObjectNumbers;
  final ScrollController scrollController;
  final bool hasMoreData;
  final bool isLoadingMore;
  final bool isDetailAvailable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.space(factor: 2)),
      child: GridView.builder(
        controller: scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: context.crossAxisCount,
          crossAxisSpacing: context.space(),
          mainAxisExtent: AdPanelWidget.getHeight(context),
        ),
        itemCount: panelObjectNumbers.length + (hasMoreData ? 1 : 0),
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
          return AdPanelWidget(
            adPanels: adPanels,
            isDetailAvailable: isDetailAvailable,
          );
        },
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
    required this.isDetailAvailable,
  });

  final Map<String, List<AdPanelEntity>> panelsMap;
  final List<String> panelObjectNumbers;
  final ScrollController scrollController;
  final bool hasMoreData;
  final bool isLoadingMore;
  final bool isDetailAvailable;

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
        return AdPanelWidget(
          adPanels: adPanels,
          isDetailAvailable: isDetailAvailable,
        );
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
