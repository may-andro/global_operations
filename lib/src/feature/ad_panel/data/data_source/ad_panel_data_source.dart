import 'dart:async';

import 'package:core/core.dart';
import 'package:global_ops/src/feature/ad_panel/data/cache/ad_panel_data_collection_path_cache.dart';

class AdPanelCollectionPathDataSource {
  AdPanelCollectionPathDataSource(this._cache, this._buildConfig) {
    _initStream();
  }

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
    final d = DateTime.utc(year, this.month, day);
    final dayNum = d.weekday == DateTime.sunday ? 7 : d.weekday;
    final thursday = d.add(Duration(days: 4 - dayNum));

    final yearStart = DateTime.utc(thursday.year);
    final daysDiff = thursday.difference(yearStart).inDays;
    final weekNo = ((daysDiff + 1) / 7).ceil();

    final month = this.month.toString().padLeft(2, '0');

    return '${thursday.year}-$month-W${weekNo.toString().padLeft(2, '0')}';
  }
}
