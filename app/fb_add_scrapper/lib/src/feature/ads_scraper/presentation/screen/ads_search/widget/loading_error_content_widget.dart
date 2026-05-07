import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fb_add_scrapper/src/feature/ads_scraper/presentation/screen/ads_search/bloc/bloc.dart';

/// Shown while initial Firestore stream is connecting.
class LoadingContentWidget extends StatelessWidget {
  const LoadingContentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: DSLoadingWidget(size: context.space(factor: 5)));
  }
}

/// Shown when the stream subscription fails on first load.
class ErrorContentWidget extends StatelessWidget {
  const ErrorContentWidget({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(context.space(factor: 4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline,
                size: context.space(factor: 6),
                color: context.colorPalette.semantic.error.color),
            SizedBox(height: context.space(factor: 2)),
            Text(message, textAlign: TextAlign.center),
            SizedBox(height: context.space(factor: 2)),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<AdsSearchBloc>().add(const RetryAdsSearchEvent()),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

