import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/domain/entity/ad_panel_entity.dart';

abstract class AdPanelRepository {
  Future<List<AdPanelEntity>> fetchAdPanels({
    int page = 1,
    bool refresh = false,
    String? field,
    String? query,
    int? limit,
  });

  Future<List<AdPanelEntity>> getAdPanelsWithDistance({
    required GeoFirePoint center,
    required double radiusInKm,
  });

  Stream<List<AdPanelEntity>> getAdPanelsWithDistanceStream({
    required GeoFirePoint center,
    required double radiusInKm,
  });

  Future<void> updateAdPanels(List<AdPanelEntity> adPanels);
}
