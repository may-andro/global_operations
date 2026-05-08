import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_list/ads_list_screen.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/widget/loading_error_content_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Scrollable list of term cards.
class ListContentWidget extends StatelessWidget {
  const ListContentWidget({super.key, required this.state});

  final AdsSearchLoadedState state;

  @override
  Widget build(BuildContext context) {
    final terms = state.filteredTerms;

    if (terms.isEmpty) return const EmptyContentWidget();

    return RefreshIndicator(
      onRefresh: () async =>
          context.read<AdsSearchBloc>().add(const LoadAdsSearchEvent()),
      child: ListView.builder(
        padding: EdgeInsets.all(context.space(factor: 2)),
        itemCount: terms.length,
        itemBuilder: (_, i) => _TermTileWidget(term: terms[i]),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Term tile — mirrors AdPanelWidget layout
// ---------------------------------------------------------------------------

class _TermTileWidget extends StatelessWidget {
  const _TermTileWidget({required this.term});

  final SearchTermEntity term;

  @override
  Widget build(BuildContext context) {
    final isDone = term.isDone;

    return DsCardWidget(
      backgroundColor: context.colorPalette.invertedBackground.primary,
      radius: context.dimen.radiusLevel2,
      elevation: context.dimen.elevationLevel1,
      margin: EdgeInsets.only(bottom: context.space()),
      onTap: isDone
          ? () => AdsListScreen.navigate(context, termId: term.id)
          : null,
      child: Padding(
        padding: EdgeInsets.all(
          context.space(factor: context.isMobile ? 2 : 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Title row ──
            Row(
              children: [
                Expanded(
                  child: DSTextWidget(
                    term.term,
                    color: context.colorPalette.neutral.grey1,
                    style: context.typography.titleMedium,
                    maxLines: 1,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isDone)
                  DSIconWidget(
                    Icons.arrow_forward_ios,
                    size: DSIconSize.small,
                    color: context.colorPalette.neutral.grey1,
                  )
                else if (term.isLoading)
                  SizedBox(
                    width: DSIconWidget.getHeight(context, DSIconSize.small),
                    height: DSIconWidget.getHeight(context, DSIconSize.small),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: context.colorPalette.brand.primary.color,
                    ),
                  ),
              ],
            ),
            SizedBox(height: context.space(factor: 0.5)),
            // ── Info rows ──
            _ItemWidget(
              icon: _statusIcon(term.status),
              label: _statusLabel(term),
              color: term.hasError
                  ? context.colorPalette.semantic.error
                  : context.colorPalette.neutral.grey4,
            ),
            if (isDone)
              _ItemWidget(
                icon: Icons.bar_chart_rounded,
                label: '${term.totalCount} ads',
                color: context.colorPalette.neutral.grey4,
              ),
            _ItemWidget(
              icon: Icons.layers_rounded,
              label: term.adType == 'POLITICAL_AND_ISSUE_ADS'
                  ? 'Political & Issue'
                  : 'All Ads',
              color: context.colorPalette.neutral.grey4,
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(SearchTermEntity term) {
    switch (term.status) {
      case SearchTermStatus.done:
        return 'Done';
      case SearchTermStatus.loading:
        return 'Scraping ads…';
      case SearchTermStatus.error:
        return term.errorMessage ?? 'Error';
      case SearchTermStatus.pending:
        return 'Queued';
    }
  }

  IconData _statusIcon(SearchTermStatus status) {
    switch (status) {
      case SearchTermStatus.done:
        return Icons.check_circle_outline_rounded;
      case SearchTermStatus.loading:
        return Icons.autorenew_rounded;
      case SearchTermStatus.error:
        return Icons.error_outline_rounded;
      case SearchTermStatus.pending:
        return Icons.hourglass_top_rounded;
    }
  }
}

// ---------------------------------------------------------------------------
// Info row — identical pattern to _ItemWidget in AdPanelWidget
// ---------------------------------------------------------------------------

class _ItemWidget extends StatelessWidget {
  const _ItemWidget({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final DSColor color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DSIconWidget(icon, size: DSIconSize.small, color: color),
        const DSHorizontalSpacerWidget(0.5),
        Flexible(
          child: DSTextWidget(
            label,
            color: color,
            style: context.typography.bodyMedium,
            maxLines: 1,
            textOverflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
