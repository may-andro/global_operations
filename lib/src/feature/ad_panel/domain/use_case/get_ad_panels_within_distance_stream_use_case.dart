import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/domain/entity/ad_panel_entity.dart';
import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';
import 'package:global_ops/src/feature/location/location.dart';

class GetAdPanelsWithinDistanceStreamParams {
  const GetAdPanelsWithinDistanceStreamParams({
    required this.location,
    required this.radiusInKm,
  });

  final LocationEntity location;
  final double radiusInKm;
}

class GetAdPanelsWithinDistanceStreamUseCase {
  GetAdPanelsWithinDistanceStreamUseCase(this._adPanelRepository);

  final AdPanelRepository _adPanelRepository;

  Stream<List<AdPanelEntity>> call(
    GetAdPanelsWithinDistanceStreamParams input,
  ) {
    return _adPanelRepository
        .getAdPanelsWithDistanceStream(
          center: GeoFirePoint(
            GeoPoint(input.location.latitude, input.location.longitude),
          ),
          radiusInKm: input.radiusInKm,
        )
        .distinct(); // Add distinct to prevent unnecessary rebuilds with same data
  }
}
