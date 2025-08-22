import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:error_reporter/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_ops/src/feature/location/domain/entity/entity.dart';
import 'package:global_ops/src/feature/system_permission/system_permission.dart';
import 'package:log_reporter/log_reporter.dart';

class TrackLocationException extends AppException {
  TrackLocationException(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'TrackLocationException: $message';
}

class TrackLocationUseCase {
  TrackLocationUseCase(this._getPermissionStatusUseCase, this._logReporter);

  final GetPermissionStatusUseCase _getPermissionStatusUseCase;
  final LogReporter _logReporter;

  LocationEntity? _lastLocation;

  Stream<LocationEntity> call({
    Duration timeout = const Duration(seconds: 30),
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
    int distanceFilterInMeters = 200,
  }) async* {
    int retryCount = 0;

    while (retryCount <= maxRetries) {
      try {
        yield* _attemptLocationStream(timeout, distanceFilterInMeters);
        break; // Success, exit retry loop
      } catch (e, st) {
        retryCount++;

        // Don't retry for permission or service errors
        if (_isNonRetryableError(e) || retryCount > maxRetries) {
          yield* Stream.error(e, st);
          break;
        }

        // Wait before retry
        await Future<void>.delayed(retryDelay);
      }
    }
  }

  Stream<LocationEntity> _attemptLocationStream(
    Duration timeout,
    int distanceFilterInMeters,
  ) async* {
    try {
      // Check permission
      final permissionResult = await _getPermissionStatusUseCase.call(
        PermissionEntity.location,
      );
      if (permissionResult.isLeft) {
        throw TrackLocationException(
          permissionResult.left.message ?? 'Location permission error',
          cause: permissionResult.left,
        );
      }
      final permissionStatus = permissionResult.right;
      if (permissionStatus != PermissionStatusEntity.granted) {
        throw TrackLocationException('Location permission denied');
      }

      // Check location services
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw TrackLocationException('Location services are disabled');
      }

      // Platform-specific location settings
      late final LocationSettings locationSettings;

      if (defaultTargetPlatform == TargetPlatform.android) {
        // Android-optimized settings
        locationSettings = AndroidSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceFilterInMeters,
          timeLimit: 2.minutes,
          forceLocationManager: true,
        );
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        // IOS-optimized settings
        locationSettings = AppleSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceFilterInMeters,
          timeLimit: 2.minutes,
          activityType: ActivityType.automotiveNavigation,
          pauseLocationUpdatesAutomatically: true,
        );
      } else {
        // Web-optimized settings
        locationSettings = WebSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: distanceFilterInMeters,
          timeLimit: 5.minutes, // Longer timeout for web
        );
      }

      // Use a longer timeout for web platforms
      final streamTimeout = kIsWeb ? 5.minutes : timeout;

      yield* Geolocator.getPositionStream(locationSettings: locationSettings)
          .timeout(
            streamTimeout,
            onTimeout: (sink) => sink.addError(
              TrackLocationException(
                'Location request timed out after ${streamTimeout.inSeconds} seconds',
              ),
            ),
          )
          .map(
            (position) => LocationEntity(
              latitude: position.latitude,
              longitude: position.longitude,
              accuracyInM: position.accuracy,
            ),
          )
          .where((newLocation) {
            _logReporter.debug(
              tag: 'TrackLocationUseCase',
              'New location update is received: $newLocation',
            );
            final isSignificant = _isLocationChangeSignificant(
              _lastLocation,
              newLocation,
              distanceFilterInMeters.toDouble(),
            );
            _logReporter.debug(
              tag: 'TrackLocationUseCase',
              'Has moved significantly: $isSignificant',
            );
            if (isSignificant) {
              _lastLocation = newLocation;
            }
            return isSignificant;
          });
    } catch (e, st) {
      if (e is TrackLocationException) {
        rethrow;
      }
      throw TrackLocationException(
        'Failed to get location: $e',
        cause: e,
        stackTrace: st,
      );
    }
  }

  /// Checks if location change is significant enough to warrant an update
  bool _isLocationChangeSignificant(
    LocationEntity? lastLocation,
    LocationEntity newLocation,
    double thresholdInMeters,
  ) {
    if (lastLocation == null) return true;

    final distance = _calculateDistance(lastLocation, newLocation);
    _logReporter.debug(
      tag: 'TrackLocationUseCase',
      'Moved distance since last update: $distance',
    );
    return distance >= thresholdInMeters;
  }

  /// Simple distance calculation between two locations
  double _calculateDistance(LocationEntity loc1, LocationEntity loc2) {
    const earthRadius = 6371000; // meters

    final lat1 = loc1.latitude * pi / 180;
    final lon1 = loc1.longitude * pi / 180;
    final lat2 = loc2.latitude * pi / 180;
    final lon2 = loc2.longitude * pi / 180;

    final dLat = lat2 - lat1;
    final dLon = lon2 - lon1;

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1) * cos(lat2) * sin(dLon / 2) * sin(dLon / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c; // distance in meters
  }

  bool _isNonRetryableError(Object error) {
    final errorMessage = error.toString().toLowerCase();
    return errorMessage.contains('permission') ||
        errorMessage.contains('service') ||
        errorMessage.contains('disabled');
  }
}
