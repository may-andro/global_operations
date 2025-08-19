import 'dart:math';

import 'package:design_system/src/component/organism/ds_map_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DSMapCluster {
  DSMapCluster(this.position, this.items, this.markers);

  LatLng position;
  List<DSMapItem> items;
  List<Marker> markers;
}

class DSMapClusterManager {
  DSMapClusterManager._();

  static Future<List<DSMapCluster>> distanceBasedCluster(
    List<DSMapItem> items,
    double zoom,
    Future<Marker> Function(DSMapItem) buildMarker,
  ) async {
    double clusterRadius;
    if (zoom <= 3) {
      clusterRadius = 300000;
    } else if (zoom <= 6) {
      clusterRadius = 80000;
    } else if (zoom <= 10) {
      clusterRadius = 10000;
    } else if (zoom <= 13) {
      clusterRadius = 2000;
    } else if (zoom <= 15) {
      clusterRadius = 200;
    } else {
      clusterRadius = 0.0001;
    }
    final List<DSMapCluster> clusters = [];
    final List<Marker> markers = await Future.wait(
      items.map((item) => buildMarker(item)),
    );
    for (int i = 0; i < markers.length; i++) {
      final marker = markers[i];
      final item = items[i];
      bool added = false;
      for (final cluster in clusters) {
        if ((marker.position.latitude - cluster.position.latitude).abs() <
                0.0000001 &&
            (marker.position.longitude - cluster.position.longitude).abs() <
                0.0000001) {
          cluster.markers.add(marker);
          cluster.items.add(item);
          added = true;
          break;
        }
        if (_distanceBetween(marker.position, cluster.position) <
            clusterRadius) {
          cluster.markers.add(marker);
          cluster.items.add(item);
          added = true;
          break;
        }
      }
      if (!added) {
        clusters.add(DSMapCluster(marker.position, [item], [marker]));
      }
    }
    for (final cluster in clusters) {
      final allSame = cluster.markers.every(
        (m) =>
            (m.position.latitude - cluster.position.latitude).abs() <
                0.0000001 &&
            (m.position.longitude - cluster.position.longitude).abs() <
                0.0000001,
      );
      if (cluster.markers.length > 1 && !allSame) {
        final lat =
            cluster.markers
                .map((m) => m.position.latitude)
                .reduce((a, b) => a + b) /
            cluster.markers.length;
        final lng =
            cluster.markers
                .map((m) => m.position.longitude)
                .reduce((a, b) => a + b) /
            cluster.markers.length;
        cluster.position = LatLng(lat, lng);
      }
    }
    return clusters;
  }

  static double _distanceBetween(LatLng a, LatLng b) {
    const earthRadius = 6371000.0;
    final dLat = _degToRad(b.latitude - a.latitude);
    final dLng = _degToRad(b.longitude - a.longitude);
    final lat1 = _degToRad(a.latitude);
    final lat2 = _degToRad(b.latitude);
    final aVal =
        (sin(dLat / 2) * sin(dLat / 2)) +
        cos(lat1) * cos(lat2) * (sin(dLng / 2) * sin(dLng / 2));
    final c = 2 * atan2(sqrt(aVal), sqrt(1 - aVal));
    return earthRadius * c;
  }

  static double _degToRad(double deg) => deg * (pi / 180.0);
}
