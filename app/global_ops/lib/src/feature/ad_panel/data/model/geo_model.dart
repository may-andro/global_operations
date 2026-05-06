import 'package:firebase/firebase.dart';

class GeoModel {
  GeoModel({required this.geohash, required this.geopoint});

  factory GeoModel.fromJson(Map<String, dynamic> json) => GeoModel(
    geohash: json['geohash'] as String,
    geopoint: GeoModel._geoPointFromJson(json['geopoint']),
  );

  final String geohash;

  final GeoPoint geopoint;

  Map<String, dynamic> toJson() => {
    'geohash': geohash,
    'geopoint': geopoint, // Store as Firestore GeoPoint
  };

  static GeoPoint _geoPointFromJson(dynamic json) {
    if (json is GeoPoint) {
      return json;
    } else if (json is List && json.length == 2) {
      return GeoPoint(json[0] as double, json[1] as double);
    }
    throw ArgumentError('Invalid geopoint format: $json');
  }
}
