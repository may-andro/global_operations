import 'package:core/core.dart';
import 'package:global_ops/src/feature/ad_panel/data/model/geo_model.dart';
import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';

class GeoMapper implements BiMapper<GeoModel, GeoEntity> {
  @override
  GeoModel from(GeoEntity from) {
    return GeoModel(geohash: from.geohash, geopoint: from.geopoint);
  }

  @override
  GeoEntity to(GeoModel from) {
    return GeoEntity(geohash: from.geohash, geopoint: from.geopoint);
  }
}
