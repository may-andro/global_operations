import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/data/data_source/ad_panel_collection_path_data_source.dart';
import 'package:global_ops/src/feature/ad_panel/data/mapper/mapper.dart';
import 'package:global_ops/src/feature/ad_panel/data/model/model.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

class AdPanelRepositoryImpl implements AdPanelRepository {
  AdPanelRepositoryImpl(
    this._fbFirestoreController,
    this._adPanelMapper,
    this._collectionPathDataSource,
  );

  final FbFirestoreController _fbFirestoreController;
  final AdPanelMapper _adPanelMapper;
  final AdPanelCollectionPathDataSource _collectionPathDataSource;

  final List<AdPanelEntity> _cachedAdPanels = [];

  String? _lastDocumentId;
  bool _hasMoreData = true;

  Future<String> get _collectionPath {
    return _collectionPathDataSource.collectionPath;
  }

  @override
  List<String> get collectionPaths {
    return _collectionPathDataSource.collectionPaths;
  }

  @override
  Stream<String> get collectionPathStream {
    return _collectionPathDataSource.collectionPathStream;
  }

  @override
  Future<void> updateCollectionPath(String value) {
    return _collectionPathDataSource.setCollectionPath(value);
  }

  @override
  Future<List<AdPanelEntity>> fetchAdPanels({
    int page = 1,
    bool refresh = false,
    String? field,
    String? query,
    int? limit,
  }) async {
    // If refreshing or first page, clear cache and reset pagination
    if (refresh || page == 1) {
      _clearCache();
    }

    // If requesting cached data and we have it, return it
    if (!refresh && page == 1 && _cachedAdPanels.isNotEmpty) {
      if (limit != null && limit < _cachedAdPanels.length) {
        return _cachedAdPanels.take(limit).toList();
      }

      return _cachedAdPanels;
    }

    // If no more data available, return empty list
    if (!_hasMoreData) {
      return [];
    }

    try {
      final dataMaps = await _fbFirestoreController.getCollectionQuerySnapshot(
        await _collectionPath,
        field: field,
        isGreaterThanOrEqualTo: query,
        isLessThan: query != null ? '$query\uf8ff' : null,
        limit: limit,
        startAfterDocumentId: _lastDocumentId,
        orderBy: _lastDocumentId != null ? field : null,
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
      if (limit == null || (remotePanels.length < limit)) {
        _hasMoreData = false;
      }

      if (remotePanels.isNotEmpty) {
        _lastDocumentId = remotePanels.last.key;
      }

      // Add to cache
      _cachedAdPanels.addAll(remotePanels);

      return remotePanels;
    } catch (e) {
      rethrow;
    }
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
          collectionPath: await _collectionPath,
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
  }) async* {
    GeoPoint geoPointFrom(Map<String, dynamic> data) =>
        (data['geo'] as Map<String, dynamic>)['geopoint'] as GeoPoint;

    await for (final path in _collectionPathDataSource.collectionPathStream) {
      yield* _fbFirestoreController
          .subscribeToGeoCollectionWithDistance(
            collectionPath: path,
            center: center,
            radiusInKm: radiusInKm,
            field: 'geo',
            geoPointFrom: geoPointFrom,
          )
          .map(
            (list) => list
                .map((map) => _adPanelMapper.to(AdPanelModel.fromJson(map)))
                .nonNulls
                .toList(),
          );
    }
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
    await _fbFirestoreController.batchUpdateDocuments(
      await _collectionPath,
      updates,
    );
  }

  void _clearCache() {
    _cachedAdPanels.clear();
    _lastDocumentId = null;
    _hasMoreData = true;
  }
}
