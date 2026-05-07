import 'package:design_system/design_system.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/domain/entity/entity.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/widget/ad_tile_widget.dart';
import 'package:flutter/material.dart';

class AdsListWidget extends StatelessWidget {
  const AdsListWidget({
    super.key,
    required this.ads,
    required this.scrollController,
    required this.isLoadingMore,
  });

  final List<FbAdEntity> ads;
  final ScrollController scrollController;
  final bool isLoadingMore;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: EdgeInsets.all(context.space(factor: 2)),
      itemCount: ads.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (_, i) {
        if (i == ads.length) {
          return Padding(
            padding: EdgeInsets.all(context.space(factor: 2)),
            child: Center(
              child: DSLoadingWidget(size: context.space(factor: 3)),
            ),
          );
        }
        return AdTileWidget(ad: ads[i]);
      },
    );
  }
}

