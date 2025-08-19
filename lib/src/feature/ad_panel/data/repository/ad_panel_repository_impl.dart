import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/data/mapper/mapper.dart';
import 'package:global_ops/src/feature/ad_panel/data/model/model.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

class AdPanelRepositoryImpl implements AdPanelRepository {
  AdPanelRepositoryImpl(this._fbFirestoreController, this._adPanelMapper);

  final FbFirestoreController _fbFirestoreController;
  final AdPanelMapper _adPanelMapper;

  final List<AdPanelEntity> cachedAdPanels = [];
  static const int _pageSize = 30;
  String? _lastDocumentId;
  bool _hasMoreData = true;

  @override
  Future<List<AdPanelEntity>> fetchAdPanels({
    int page = 1,
    bool refresh = false,
  }) async {
    // If refreshing or first page, clear cache and reset pagination
    if (refresh || page == 1) {
      _clearCache();
    }

    // If requesting cached data and we have it, return it
    if (!refresh && page == 1 && cachedAdPanels.isNotEmpty) {
      return cachedAdPanels.take(_pageSize).toList();
    }

    // If no more data available, return empty list
    if (!_hasMoreData) {
      return [];
    }

    try {
      final dataMaps = await _fbFirestoreController.getCollectionQuerySnapshot(
        _collectionPath,
        limit: _pageSize,
        startAfterDocumentId: _lastDocumentId,
      );

      if (dataMaps.isEmpty) {
        _hasMoreData = false;
        return [];
      }

      final remotePanels = dataMaps
          .map((map) => _adPanelMapper.to(AdPanelModel.fromJson(map)))
          .nonNulls
          .toList();

      // Update pagination state
      if (remotePanels.length < _pageSize) {
        _hasMoreData = false;
      }

      if (remotePanels.isNotEmpty) {
        _lastDocumentId = remotePanels.last.key;
      }

      // Add to cache
      cachedAdPanels.addAll(remotePanels);

      return remotePanels;
    } catch (e) {
      rethrow;
    }
  }

  // Make clearCache private to hide implementation details
  void _clearCache() {
    cachedAdPanels.clear();
    _lastDocumentId = null;
    _hasMoreData = true;
  }

  @override
  Future<List<AdPanelEntity>> getAdPanelsWithDistance({
    required GeoFirePoint center,
    required double radiusInKm,
  }) async {
    GeoPoint geoPointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

    final geoCollectionWithDistance = await _fbFirestoreController
        .getGeoCollectionWithDistance(
          collectionPath: _collectionPath,
          center: center,
          radiusInKm: radiusInKm,
          field: 'geo',
          geoPointFrom: geoPointFrom,
        );
    return geoCollectionWithDistance
        .map((map) => _adPanelMapper.to(AdPanelModel.fromJson(map)))
        .nonNulls
        .toList();
  }

  @override
  Stream<List<AdPanelEntity>> getAdPanelsWithDistanceStream({
    required GeoFirePoint center,
    required double radiusInKm,
  }) {
    GeoPoint geoPointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

    return _fbFirestoreController
        .subscribeToGeoCollectionWithDistance(
          collectionPath: _collectionPath,
          center: center,
          radiusInKm: radiusInKm,
          field: 'geo',
          geoPointFrom: geoPointFrom,
        )
        .map((list) {
          return list
              .map((map) => _adPanelMapper.to(AdPanelModel.fromJson(map)))
              .nonNulls
              .toList();
        });
  }

  @override
  Future<void> updateAdPanels(List<AdPanelEntity> adPanels) async {
    final updates = adPanels
        .map(
          (panel) => {
            'documentPath': panel.key,
            'data': _adPanelMapper.from(panel).toJson(),
          },
        )
        .toList();
    await _fbFirestoreController.batchUpdateDocuments(_collectionPath, updates);
  }

  String get _collectionPath {
    final date = DateTime.now();
    return 'snowflake_record_${date.yearMonthWeek}';
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
