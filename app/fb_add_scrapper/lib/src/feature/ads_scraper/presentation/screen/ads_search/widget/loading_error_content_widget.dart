import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Full-screen loading indicator.
class LoadingContentWidget extends StatelessWidget {
  const LoadingContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: DSLoadingWidget(size: context.space(factor: 5)));
  }
}

/// Full-screen error card with retry button.
class ErrorContentWidget extends StatelessWidget {
  const ErrorContentWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return DSErrorCardWidget(
      message: message,
      onRetryClicked: () =>
          context.read<AdsSearchBloc>().add(const RetryAdsSearchEvent()),
    );
  }
}

/// Shown when there are no search terms yet.
class EmptyContentWidget extends StatelessWidget {
  const EmptyContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: 4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DSIconWidget(
              Icons.inbox_outlined,
              color: context.colorPalette.neutral.grey4,
              size: DSIconSize.large,
            ),
            const DSVerticalSpacerWidget(2),
            DSTextWidget(
              'No search terms yet',
              style: context.typography.titleMedium,
              color: context.colorPalette.background.onPrimary,
              textAlign: TextAlign.center,
            ),
            const DSVerticalSpacerWidget(1),
            DSTextWidget(
              'Add a term above to start scraping Facebook Ads.',
              style: context.typography.bodyMedium,
              color: context.colorPalette.background.onPrimary,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
