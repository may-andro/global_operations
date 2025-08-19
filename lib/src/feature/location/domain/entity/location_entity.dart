import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:vector_math/vector_math.dart';

class LocationEntity extends Equatable {
  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracyInM,
  });

  final double latitude;
  final double longitude;
  final double? accuracyInM;

  /// Calculates the distance between this location and the [location] passed in km.
  /// Calculation is done based on the (Haversine_formula)[https://en.wikipedia.org/wiki/Haversine_formula]
  double distanceToInKm(LocationEntity location) {
    const earthDiameter = 12742; // Diameter of the earth in km (2 * 6371)
    final haversineFormulaResult =
        0.5 -
        cos(radians(location.latitude - latitude)) / 2 +
        cos(radians(latitude)) *
            cos(radians(location.latitude)) *
            (1 - cos(radians(location.longitude - longitude))) /
            2;

    return earthDiameter * asin(sqrt(haversineFormulaResult));
  }

  @override
  List<Object?> get props => [latitude, longitude, accuracyInM];
}
