import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/widget/ads_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Handles the search-tab content based on the current [AdsScrapeState].
/// Mirrors the `_ViewStateBuilderWidget` pattern used in AdPanels screens.
class SearchContentWidget extends StatelessWidget {
  const SearchContentWidget({
    super.key,
    required this.scrollController,
    required this.onSearch,
  });

  final ScrollController scrollController;
  final VoidCallback onSearch;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsScrapeBloc, AdsScrapeState>(
      builder: (context, state) {
        return switch (state.status) {
          AdsScrapeStatus.loading => Center(
            child: DSLoadingWidget(size: context.space(factor: 5)),
          ),
          AdsScrapeStatus.failure => DSErrorCardWidget(
            message: state.errorMessage,
            onRetryClicked: onSearch,
          ),
          AdsScrapeStatus.success when state.ads.isEmpty =>
            _EmptyContentWidget(onRetry: onSearch),
          AdsScrapeStatus.loadingMore || AdsScrapeStatus.success =>
            AdsListWidget(
              ads: state.ads,
              scrollController: scrollController,
              isLoadingMore: state.status == AdsScrapeStatus.loadingMore,
            ),
          _ => _EmptyContentWidget(onRetry: null),
        };
      },
    );
  }
}

class _EmptyContentWidget extends StatelessWidget {
  const _EmptyContentWidget({this.onRetry});

  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: 4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DSIconWidget(
              Icons.search_off_outlined,
              size: DSIconSize.xLarge,
              color: context.colorPalette.neutral.grey3,
            ),
            SizedBox(height: context.space(factor: 2)),
            DSTextWidget(
              'No ads found.\nTry different search terms.',
              style: context.typography.bodyMedium,
              color: context.colorPalette.neutral.grey5,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: context.space(factor: 2)),
              DSButtonWidget(
                label: 'Retry',
                onPressed: onRetry!,
                variant: DSButtonVariant.secondary,
                size: DSButtonSize.small,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

