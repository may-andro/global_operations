import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:global_ops/src/feature/ad_panel/domain/entity/ad_panel_entity.dart';
import 'package:global_ops/src/feature/ad_panel/domain/repository/repository.dart';
import 'package:global_ops/src/feature/location/location.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class GetAdPanelsWithinDistanceFailure extends BasicFailure {
  const GetAdPanelsWithinDistanceFailure({super.message, super.cause});
}

class GetAdPanelsWithinDistanceParams {
  const GetAdPanelsWithinDistanceParams({
    required this.location,
    required this.radiusInKm,
  });

  final LocationEntity location;
  final double radiusInKm;
}

class GetAdPanelsWithinDistanceUseCase
    extends
        BaseUseCase<
          List<AdPanelEntity>,
          GetAdPanelsWithinDistanceParams,
          GetAdPanelsWithinDistanceFailure
        > {
  GetAdPanelsWithinDistanceUseCase(this._adPanelRepository);

  final AdPanelRepository _adPanelRepository;

  @override
  @protected
  FutureOr<Either<GetAdPanelsWithinDistanceFailure, List<AdPanelEntity>>>
  execute(GetAdPanelsWithinDistanceParams input) async {
    final adPanels = await _adPanelRepository.getAdPanelsWithDistance(
      center: GeoFirePoint(
        GeoPoint(input.location.latitude, input.location.longitude),
      ),
      radiusInKm: input.radiusInKm,
    );
    return Right(adPanels);
  }

  @override
  GetAdPanelsWithinDistanceFailure mapErrorToFailure(Object e, StackTrace st) {
    return GetAdPanelsWithinDistanceFailure(message: e.toString(), cause: st);
  }
}
