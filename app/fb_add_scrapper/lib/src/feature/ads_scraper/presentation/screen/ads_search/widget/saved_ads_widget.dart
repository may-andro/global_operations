import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/widget/ad_tile_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavedAdsWidget extends StatelessWidget {
  const SavedAdsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdsScrapeBloc, AdsScrapeState>(
      builder: (context, state) {
        if (state.savedAds.isEmpty) {
          return const _EmptyContentWidget(
            message: 'No saved ads yet.\nSearch and they will auto-save.',
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(context.space(factor: 2)),
          itemCount: state.savedAds.length,
          itemBuilder: (_, i) => AdTileWidget(
            ad: state.savedAds[i],
            trailing: IconButton(
              icon: DSIconWidget(
                Icons.delete_outline,
                color: context.colorPalette.semantic.error,
                size: DSIconSize.medium,
              ),
              onPressed: () => context
                  .read<AdsScrapeBloc>()
                  .add(DeleteSavedAdEvent(state.savedAds[i].id)),
            ),
          ),
        );
      },
    );
  }
}

class _EmptyContentWidget extends StatelessWidget {
  const _EmptyContentWidget({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: 4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DSIconWidget(
              Icons.bookmarks_outlined,
              size: DSIconSize.xLarge,
              color: context.colorPalette.neutral.grey3,
            ),
            SizedBox(height: context.space(factor: 2)),
            DSTextWidget(
              message,
              style: context.typography.bodyMedium,
              color: context.colorPalette.neutral.grey5,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

