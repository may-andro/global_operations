import 'package:design_system/src/component/organism/ds_map_cluster_manager.dart';
import 'package:design_system/src/component/organism/ds_map_marker_generator.dart';
import 'package:design_system/src/extension/build_context_extension.dart';
import 'package:design_system/src/service/map_style_service.dart';
import 'package:design_system/src/theme/theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Represents a single item to be displayed on the map
class DSMapItem {
  const DSMapItem({
    required this.id,
    required this.latitude,
    required this.longitude,
    this.isSelected = false,
  });

  final String id;
  final double latitude;
  final double longitude;
  final bool isSelected;
}

/// A customizable Google Maps widget with clustering and theming support
///
/// Features:
/// - Automatic marker clustering based on zoom level
/// - Theme-aware map styling (light/dark modes)
/// - Custom marker generation
/// - Radius circles
/// - Smooth camera animations
class DSMapWidget extends StatefulWidget {
  const DSMapWidget({
    super.key,
    required this.center,
    required this.items,
    this.initialZoom = 15,
    this.onMarkerTap,
    this.onMultipleMarkersOnSameSpotClusterTap,
    this.controller,
    this.circleRadius = 0,
    this.customMapStyle,
    this.enableAutoThemeStyle = true,
  });

  /// The center position of the map
  final LatLng center;

  /// List of items to display as markers on the map
  final List<DSMapItem> items;

  /// Initial zoom level (default: 15)
  final double initialZoom;

  /// Callback when a single marker is tapped
  final void Function(Marker, List<DSMapItem>)? onMarkerTap;

  /// Callback when multiple markers at the same location are tapped
  final void Function(LatLng, List<DSMapItem>)?
  onMultipleMarkersOnSameSpotClusterTap;

  /// Controller for programmatic map control
  final DSMapController? controller;

  /// Radius of the circle overlay (0 = no circle)
  final double circleRadius;

  /// Custom map style JSON string (overrides auto theme styling)
  final String? customMapStyle;

  /// Whether to automatically apply theme-based styling (default: true)
  final bool enableAutoThemeStyle;

  @override
  State<DSMapWidget> createState() => _DSMapWidgetState();
}

class _DSMapWidgetState extends State<DSMapWidget> {
  // Map state
  Set<Marker> _displayMarkers = {};
  GoogleMapController? _mapController;
  double _currentZoom = 15;
  String? _mapStyle;

  // Theme and styling
  DSTheme get _theme => context.theme;

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load map style here since we need access to Theme.of(context)
    if (widget.enableAutoThemeStyle && widget.customMapStyle == null) {
      _loadMapStyle();
    }
  }

  /// Initialize map with markers and styling
  void _initializeMap() {
    _currentZoom = widget.initialZoom;

    // Set custom map style if provided (doesn't require theme context)
    if (widget.customMapStyle != null) {
      _mapStyle = widget.customMapStyle;
    }

    // Setup controller callbacks
    widget.controller?._attachUpdateMarkersCallback = (items) =>
        _updateClustersCommon(items, fitBounds: true);

    // Initial marker setup
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(300.ms);
      await _updateClustersCommon(widget.items, fitBounds: true);
    });
  }

  /// Load appropriate map style based on current theme
  Future<void> _loadMapStyle() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final mapStyle = await MapStyleService.getStyleForTheme(
      isDarkMode: isDarkMode,
    );

    if (mounted) {
      setState(() {
        _mapStyle = mapStyle;
      });
    }
  }

  Future<void> _updateClusters({bool fitBounds = false}) async {
    await _updateClustersCommon(widget.items, fitBounds: fitBounds);
  }

  Future<void> _updateClustersCommon(
    List<DSMapItem> items, {
    bool fitBounds = false,
  }) async {
    final List<DSMapCluster> clusters =
        await DSMapClusterManager.distanceBasedCluster(
          items,
          _currentZoom,
          _buildMarker,
        );
    final Set<Marker> displayMarkers = {};
    for (final cluster in clusters) {
      final allSame =
          cluster.markers.length > 1 &&
          cluster.markers.every(
            (marker) =>
                (marker.position.latitude - cluster.position.latitude).abs() <
                    0.0000001 &&
                (marker.position.longitude - cluster.position.longitude).abs() <
                    0.0000001,
          );
      if (cluster.markers.length == 1) {
        // Single marker: call onMarkerTap
        final markerId = cluster.markers.first.markerId.value;
        final icon = await DsMapMarkerGenerator.createBitmap(
          markerId,
          cluster.items.first.isSelected,
          1,
          _theme,
        );
        final marker = cluster.markers.first.copyWith(
          iconParam: icon,
          onTapParam: () {
            widget.onMarkerTap?.call(cluster.markers.first, cluster.items);
          },
          infoWindowParam: InfoWindow(title: cluster.items.first.id),
        );
        displayMarkers.add(marker);
      } else if (allSame && cluster.markers.length > 1) {
        // Multiple markers at the same spot: call onMultipleMarkersOnSameSpotClusterTap
        final markerId = cluster.markers.first.markerId.value;
        final icon = await DsMapMarkerGenerator.createBitmap(
          markerId,
          false,
          cluster.markers.length,
          _theme,
        );
        final marker = cluster.markers.first.copyWith(
          iconParam: icon,
          onTapParam: () {
            widget.onMultipleMarkersOnSameSpotClusterTap?.call(
              cluster.position,
              cluster.items,
            );
          },
        );
        displayMarkers.add(marker);
      } else {
        final clusterIcon = await DsMapMarkerGenerator.createBitmap(
          'cluster_${cluster.markers.length}',
          false,
          cluster.markers.length,
          _theme,
        );
        displayMarkers.add(
          Marker(
            markerId: MarkerId(
              '__cluster__${cluster.position.latitude}_${cluster.position.longitude}',
            ),
            position: cluster.position,
            icon: clusterIcon ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: '${cluster.markers.length} items'),
            onTap: () async {
              await _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(cluster.position, _currentZoom + 2),
              );
            },
          ),
        );
      }
    }
    setState(() {
      _displayMarkers = displayMarkers;
    });
    if (fitBounds) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
      await _fitBoundsToClusters(clusters);
    }
  }

  Future<void> _fitBoundsToClusters(
    List<DSMapCluster> clusters, {
    bool animate = true,
  }) async {
    if (clusters.isEmpty || _mapController == null) return;

    // On web, add extra delay to ensure map is fully ready
    if (kIsWeb) {
      await Future<void>.delayed(const Duration(milliseconds: 500));
    }

    double? minLat;
    double? maxLat;
    double? minLng;
    double? maxLng;
    for (final cluster in clusters) {
      final lat = cluster.position.latitude;
      final lng = cluster.position.longitude;
      minLat = minLat == null ? lat : (minLat < lat ? minLat : lat);
      maxLat = maxLat == null ? lat : (maxLat > lat ? maxLat : lat);
      minLng = minLng == null ? lng : (minLng < lng ? minLng : lng);
      maxLng = maxLng == null ? lng : (maxLng > lng ? maxLng : lng);
    }

    if (minLat != null && maxLat != null && minLng != null && maxLng != null) {
      await _performBoundsFit(
        minLat,
        maxLat,
        minLng,
        maxLng,
        clusters,
        animate,
      );
    }
  }

  Future<void> _performBoundsFit(
    double minLat,
    double maxLat,
    double minLng,
    double maxLng,
    List<DSMapCluster> clusters,
    bool animate,
  ) async {
    try {
      final bounds = LatLngBounds(
        southwest: LatLng(minLat, minLng),
        northeast: LatLng(maxLat, maxLng),
      );

      // For web, use a more robust approach
      if (kIsWeb) {
        await _fitBoundsForWeb(bounds, minLat, maxLat, minLng, maxLng, animate);
        return;
      }

      // Original logic for mobile platforms
      final visibleRegion = await _mapController!.getVisibleRegion();
      final currentZoom = _currentZoom;
      final boundsContain =
          visibleRegion.southwest.latitude <= minLat &&
          visibleRegion.northeast.latitude >= maxLat &&
          visibleRegion.southwest.longitude <= minLng &&
          visibleRegion.northeast.longitude >= maxLng;

      // Calculate span of visible region and new bounds
      final visibleLatSpan =
          (visibleRegion.northeast.latitude - visibleRegion.southwest.latitude)
              .abs();
      final visibleLngSpan =
          (visibleRegion.northeast.longitude -
                  visibleRegion.southwest.longitude)
              .abs();
      final boundsLatSpan = (maxLat - minLat).abs();
      final boundsLngSpan = (maxLng - minLng).abs();

      // If new bounds are much smaller than visible region, force fit
      final boundsMuchSmaller =
          (boundsLatSpan < visibleLatSpan * 0.5) &&
          (boundsLngSpan < visibleLngSpan * 0.5);

      // Always fit bounds if zoomed out very far or bounds are much smaller
      final forceFit = currentZoom < 6 || boundsMuchSmaller;

      if (minLat == maxLat && minLng == maxLng) {
        final target = LatLng(minLat, minLng);
        if (!boundsContain || forceFit) {
          if (animate) {
            await _mapController!.animateCamera(
              CameraUpdate.newLatLngZoom(target, 16),
            );
          } else {
            await _mapController!.moveCamera(
              CameraUpdate.newLatLngZoom(target, 16),
            );
          }
        }
      } else {
        if (!boundsContain || forceFit) {
          if (animate) {
            await _mapController!.animateCamera(
              CameraUpdate.newLatLngBounds(bounds, 80),
            );
          } else {
            await _mapController!.moveCamera(
              CameraUpdate.newLatLngBounds(bounds, 80),
            );
          }
        }
      }
    } catch (e) {
      // Fallback: center on first cluster
      final fallback = clusters.first.position;
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(fallback, 16),
      );
    }
  }

  Future<void> _fitBoundsForWeb(
    LatLngBounds bounds,
    double minLat,
    double maxLat,
    double minLng,
    double maxLng,
    bool animate,
  ) async {
    try {
      // For single point, just center the map
      if (minLat == maxLat && minLng == maxLng) {
        final target = LatLng(minLat, minLng);
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(target, 16),
        );
        return;
      }

      // Try multiple approaches for web bounds fitting
      bool success = false;

      // Approach 1: Use newLatLngBounds with larger padding
      try {
        if (animate) {
          await _mapController!.animateCamera(
            CameraUpdate.newLatLngBounds(bounds, 120),
          );
        } else {
          await _mapController!.moveCamera(
            CameraUpdate.newLatLngBounds(bounds, 120),
          );
        }
        success = true;
      } catch (e) {
        // Continue to fallback approaches
      }

      // Approach 2: Calculate center and zoom manually
      if (!success) {
        try {
          final centerLat = (minLat + maxLat) / 2;
          final centerLng = (minLng + maxLng) / 2;
          final center = LatLng(centerLat, centerLng);

          // Calculate appropriate zoom level based on bounds span
          final latSpan = (maxLat - minLat).abs();
          final lngSpan = (maxLng - minLng).abs();
          final maxSpan = latSpan > lngSpan ? latSpan : lngSpan;

          double zoom = 16;
          if (maxSpan > 0.1) {
            zoom = 10;
          } else if (maxSpan > 0.05) {
            zoom = 12;
          } else if (maxSpan > 0.01) {
            zoom = 14;
          } else if (maxSpan > 0.005) {
            zoom = 15;
          }

          await _mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(center, zoom),
          );
          success = true;
        } catch (e) {
          // Continue to final fallback
        }
      }

      // Approach 3: Simple center on first point
      if (!success) {
        final fallback = LatLng(minLat, minLng);
        await _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(fallback, 14),
        );
      }
    } catch (e) {
      // Final fallback
      final fallback = LatLng(minLat, minLng);
      await _mapController!.moveCamera(
        CameraUpdate.newLatLngZoom(fallback, 14),
      );
    }
  }

  Future<Marker> _buildMarker(DSMapItem item) async {
    final lat = item.latitude;
    final lng = item.longitude;
    final markerId = item.id;
    final icon = await DsMapMarkerGenerator.createBitmap(
      markerId,
      item.isSelected,
      1,
      _theme,
    );
    return Marker(
      markerId: MarkerId(markerId),
      position: LatLng(lat, lng),
      icon: icon ?? BitmapDescriptor.defaultMarker,
      onTap: () => widget.onMarkerTap?.call(
        Marker(
          markerId: MarkerId(markerId),
          position: LatLng(lat, lng),
          icon: icon ?? BitmapDescriptor.defaultMarker,
        ),
        [item],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildGoogleMap();
  }

  /// Build the Google Maps widget with proper configuration
  Widget _buildGoogleMap() {
    final circle = _buildRadiusCircle();

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.center,
        zoom: _currentZoom,
      ),
      style: _mapStyle,
      myLocationEnabled: true,
      circles: widget.circleRadius > 0 ? {circle} : {},
      markers: _displayMarkers,
      onMapCreated: _onMapCreated,
      onCameraMove: _onCameraMove,
      onCameraIdle: _onCameraIdle,
    );
  }

  /// Build the radius circle overlay
  Circle _buildRadiusCircle() {
    return Circle(
      circleId: const CircleId('radius'),
      center: widget.center,
      radius: widget.circleRadius,
      fillColor: _theme.colorPalette.brand.primary.color.withAlpha(20),
      strokeColor: _theme.colorPalette.brand.primary.color,
      strokeWidth: 1,
    );
  }

  /// Handle map creation
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    widget.controller?._attachMapController = controller;
    _updateClusters();
  }

  /// Handle camera movement
  void _onCameraMove(CameraPosition position) {
    _currentZoom = position.zoom;
  }

  /// Handle camera idle (after movement/zoom stops)
  void _onCameraIdle() {
    _updateClusters();
  }
}

class DSMapController extends ChangeNotifier {
  GoogleMapController? _googleMapController;
  void Function(List<DSMapItem>)? _updateMarkersCallback;

  // Called by DSMapWidget to register the GoogleMapController
  // ignore: avoid_setters_without_getters
  set _attachMapController(GoogleMapController controller) {
    _googleMapController = controller;
  }

  // Called by DSMapWidget to register a callback for updating markers
  // ignore: avoid_setters_without_getters
  set _attachUpdateMarkersCallback(void Function(List<DSMapItem>) callback) {
    _updateMarkersCallback = callback;
  }

  GoogleMapController? get googleMapController => _googleMapController;

  // Call this to update markers from outside
  void updateMarkers(List<DSMapItem> items) {
    _updateMarkersCallback?.call(items);
  }
}
