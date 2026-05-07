import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/widget/widget.dart';
import 'package:fb_add_scrapper/src/module_injector/app_module_configurator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdsListScreen extends StatelessWidget {
  const AdsListScreen({super.key, required this.termId});

  final String termId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          appServiceLocator.get<AdsListBloc>()
            ..add(LoadAdsListEvent(termId: termId)),
      child: _AdsListView(termId: termId),
    );
  }
}

// ---------------------------------------------------------------------------

class _AdsListView extends StatefulWidget {
  const _AdsListView({required this.termId});

  final String termId;

  @override
  State<_AdsListView> createState() => _AdsListViewState();
}

class _AdsListViewState extends State<_AdsListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<AdsListBloc>().state;
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.9 &&
        state.hasMore &&
        !state.isLoading) {
      context.read<AdsListBloc>().add(const LoadMoreAdsListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorPalette.background.primary.color,
      appBar: AppBar(
        backgroundColor: context.colorPalette.background.primary.color,
        surfaceTintColor:
            context.colorPalette.neutral.transparent.color,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: BlocBuilder<AdsListBloc, AdsListState>(
          buildWhen: (p, c) => p.termId != c.termId || p.filteredAds.length != c.filteredAds.length,
          builder: (context, state) {
            final title =
                widget.termId.replaceAll('_', ' ');
            final count = state.status == AdsListStatus.success ||
                    state.status == AdsListStatus.loadingMore
                ? ' (${state.filteredAds.length}${state.filter.isActive ? ' filtered' : ''})'
                : '';
            return DSTextWidget(
              '$title$count',
              style: context.typography.titleMedium,
              color: context.colorPalette.neutral.grey1,
              maxLines: 1,
              textOverflow: TextOverflow.ellipsis,
            );
          },
        ),
      ),
      body: Column(
        children: [
          // ── Filter bar ──
          const AdsFilterBarWidget(),
          DSHorizontalDividerWidget(
            color: context.colorPalette.neutral.grey8,
          ),
          // ── Content ──
          Expanded(
            child: BlocBuilder<AdsListBloc, AdsListState>(
              builder: (context, state) {
                // Initial full-page loading
                if (state.status == AdsListStatus.loading) {
                  return DSLoadingWidget(size: context.space(factor: 5));
                }

                // Error with empty list
                if (state.status == AdsListStatus.failure &&
                    state.ads.isEmpty) {
                  return _ErrorView(
                    message:
                        state.errorMessage ?? 'Something went wrong.',
                    onRetry: () => context.read<AdsListBloc>().add(
                          LoadAdsListEvent(termId: widget.termId),
                        ),
                  );
                }

                final ads = state.filteredAds;

                if (ads.isEmpty) {
                  return _EmptyView(
                    hasFilter: state.filter.isActive,
                    onClearFilter: () => context
                        .read<AdsListBloc>()
                        .add(const FilterAdsListEvent(clearAll: true)),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async => context.read<AdsListBloc>().add(
                        LoadAdsListEvent(termId: widget.termId),
                      ),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.all(context.space(factor: 2)),
                    itemCount:
                        ads.length + (state.isLoading ? 1 : 0),
                    itemBuilder: (_, i) {
                      if (i == ads.length) {
                        return Padding(
                          padding: EdgeInsets.all(context.space(factor: 2)),
                          child: DSLoadingWidget(
                            size: context.space(factor: 3),
                          ),
                        );
                      }
                      return AdCardWidget(ad: ads[i]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Empty state
// ---------------------------------------------------------------------------

class _EmptyView extends StatelessWidget {
  const _EmptyView({required this.hasFilter, required this.onClearFilter});

  final bool hasFilter;
  final VoidCallback onClearFilter;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: 3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DSIconWidget(
              Icons.search_off_rounded,
              size: DSIconSize.large,
              color: context.colorPalette.neutral.grey6,
            ),
            SizedBox(height: context.space()),
            DSTextWidget(
              hasFilter
                  ? 'No ads match the current filters.'
                  : 'No ads found for this term.',
              color: context.colorPalette.neutral.grey4,
              style: context.typography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (hasFilter) ...[
              SizedBox(height: context.space()),
              TextButton(
                onPressed: onClearFilter,
                child: Text(
                  'Clear filters',
                  style: context.typography.labelMedium.textStyle.copyWith(
                    color: context.colorPalette.brand.primary.color,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Error state
// ---------------------------------------------------------------------------

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: 3)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DSIconWidget(
              Icons.error_outline_rounded,
              size: DSIconSize.large,
              color: context.colorPalette.semantic.error,
            ),
            SizedBox(height: context.space()),
            DSTextWidget(
              message,
              color: context.colorPalette.neutral.grey3,
              style: context.typography.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: context.space()),
            TextButton(
              onPressed: onRetry,
              child: Text(
                'Try again',
                style: context.typography.labelMedium.textStyle.copyWith(
                  color: context.colorPalette.brand.primary.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

