import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/search_term_entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/route/ads_scraper_module_route.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Scrollable list of search terms with infinite-scroll support.
/// Equivalent to ListContentWidget in paginated_ad_panels.
class ListContentWidget extends StatelessWidget {
  const ListContentWidget({super.key, required this.state});

  final AdsSearchLoadedState state;

  @override
  Widget build(BuildContext context) {
    final terms = state.terms;

    if (terms.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(context.space(factor: 4)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off,
                  size: context.space(factor: 6),
                  color: context.colorPalette.background.onPrimary.color
                      .withOpacity(0.4)),
              SizedBox(height: context.space(factor: 2)),
              Text(
                'No search terms yet.\nAdd one above!',
                textAlign: TextAlign.center,
                style: context.typography.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(context.space(factor: 2)),
      itemCount: terms.length,
      itemBuilder: (_, i) => _TermTileWidget(term: terms[i]),
    );
  }
}

// ---------------------------------------------------------------------------
// Term tile
// ---------------------------------------------------------------------------

class _TermTileWidget extends StatelessWidget {
  const _TermTileWidget({required this.term});

  final SearchTermEntity term;

  @override
  Widget build(BuildContext context) {
    return DsCardWidget(
      backgroundColor: context.colorPalette.background.primary,
      elevation: context.dimen.elevationLevel2,
      radius: context.dimen.radiusLevel2,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: context.space(factor: 2),
          vertical: context.space(),
        ),
        title: Text(
          term.term,
          style: context.typography.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _buildSubtitle(context),
        trailing: _StatusBadge(status: term.status),
        onTap: term.isDone
            ? () => context.pushNamed(
                  AdsScraperModuleRoute.termAdsList.name,
                  pathParameters: {'termId': term.id},
                )
            : null,
      ),
    );
  }

  Widget? _buildSubtitle(BuildContext context) {
    if (term.isDone) {
      return Text(
        '${term.totalCount} ads',
        style: context.typography.bodySmall.copyWith(
          color: context.colorPalette.semantic.success.color,
        ),
      );
    }
    if (term.hasError) {
      return Text(
        term.errorMessage ?? 'Unknown error',
        style: context.typography.bodySmall.copyWith(
          color: context.colorPalette.semantic.error.color,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    }
    if (term.isLoading) {
      return Text(
        'Scraping ads...',
        style: context.typography.bodySmall,
      );
    }
    return null;
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SearchTermStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SearchTermStatus.loading:
        return SizedBox(
          width: context.space(factor: 2.5),
          height: context.space(factor: 2.5),
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: context.colorPalette.brand.primary.color,
          ),
        );
      case SearchTermStatus.done:
        return Icon(Icons.check_circle_rounded,
            color: context.colorPalette.semantic.success.color);
      case SearchTermStatus.error:
        return Icon(Icons.error_rounded,
            color: context.colorPalette.semantic.error.color);
      case SearchTermStatus.pending:
        return Icon(Icons.hourglass_empty_rounded,
            color: context.colorPalette.background.onPrimary.color
                .withOpacity(0.4));
    }
  }
}

