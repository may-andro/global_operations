import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/widget/add_term_widget.dart';
import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/widget/list_content_widget.dart';
import 'package:flutter/material.dart';

/// Shown when the stream is loaded — combines AddTermWidget + ListContentWidget.
/// Equivalent to ContentWidget in paginated_ad_panels.
class ContentWidget extends StatelessWidget {
  const ContentWidget({super.key, required this.state});

  final AdsSearchLoadedState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const AddTermWidget(),
        Expanded(child: ListContentWidget(state: state)),
      ],
    );
  }
}

