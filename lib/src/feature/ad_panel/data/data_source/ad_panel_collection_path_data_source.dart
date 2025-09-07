import 'dart:async';

import 'package:core/core.dart';
import 'package:global_ops/src/feature/ad_panel/data/cache/ad_panel_data_collection_path_cache.dart';
import 'package:global_ops/src/feature/feature_toggle/feature_toggle.dart';

class AdPanelCollectionPathDataSource {
  AdPanelCollectionPathDataSource(
    this._cache,
    this._buildConfig,
    this._featureFlagRepository,
  ) {
    _initStream();
  }

  final FeatureFlagRepository _featureFlagRepository;
  final AdPanelDataCollectionPathCache _cache;
  final BuildConfig _buildConfig;

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  Future<void> _initStream() async {
    final initial = await collectionPath;
    _controller.add(initial);
  }

  List<String> get collectionPaths {
    return [
      'snowflake_record_demo',
      'snowflake_record_${DateTime.now().yearMonthWeek}',
    ];
  }

  Future<String> get collectionPath async {
    final isFeatureEnabled = await _featureFlagRepository.isFeatureEnabled(
      Feature.forceDemoData,
    );
    if (isFeatureEnabled) {
      return collectionPaths[0];
    }

    final cachedCollectionPath = await _cache.get();
    if (cachedCollectionPath != null) {
      return cachedCollectionPath;
    }

    if (_buildConfig.buildEnvironment.isFakeDataEnabled) {
      return collectionPaths[0];
    }

    return collectionPaths[1];
  }

  Stream<String> get collectionPathStream async* {
    // Emit the initial value first
    yield await collectionPath;
    // Then emit all subsequent values from the controller
    yield* _controller.stream;
  }

  Future<void> setCollectionPath(String value) {
    _controller.add(value);
    return _cache.put(value);
  }

  Future<void> clearCollectionPath() async {
    _controller.add(await collectionPath);
    await _cache.delete();
  }
}

extension on DateTime {
  String get yearMonthWeek {
    final utcDate = toUtc();
    final dayOfWeek = utcDate.weekday == DateTime.sunday ? 7 : utcDate.weekday;
    final thursday = utcDate.subtract(Duration(days: dayOfWeek - 4));
    final isoYear = thursday.year;
    final firstThursday = DateTime.utc(isoYear, 1, 4);
    final firstThursdayWeekday = firstThursday.weekday == DateTime.sunday
        ? 7
        : firstThursday.weekday;
    final firstIsoThursday = firstThursday.subtract(
      Duration(days: firstThursdayWeekday - 4),
    );
    final weekNumber =
        ((thursday.difference(firstIsoThursday).inDays) / 7).floor() + 1;

    return '$isoYear-W${weekNumber.toString().padLeft(2, '0')}';
  }
}
