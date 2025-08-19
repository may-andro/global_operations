import 'dart:async';

import 'package:core/core.dart';
import 'package:error_reporter/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:global_ops/src/feature/location/domain/entity/entity.dart';
import 'package:global_ops/src/feature/system_permission/system_permission.dart';

class TrackLocationException extends AppException {
  TrackLocationException(this.message, {this.cause, this.stackTrace});

  final String message;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() => 'TrackLocationException: $message';
}

class TrackLocationUseCase {
  TrackLocationUseCase(this._getPermissionStatusUseCase);

  final GetPermissionStatusUseCase _getPermissionStatusUseCase;

  Stream<LocationEntity> call({
    Duration timeout = const Duration(seconds: 30),
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 2),
  }) async* {
    int retryCount = 0;

    while (retryCount <= maxRetries) {
      try {
        yield* _attemptLocationStream(timeout);
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

  Stream<LocationEntity> _attemptLocationStream(Duration timeout) async* {
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

      if (kIsWeb) {
        // Web-optimized settings
        locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50, // Only update when user moves 50+ meters
          timeLimit: 5.minutes, // Longer timeout for web
        );
      } else {
        // Mobile-optimized settings
        locationSettings = LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 50, // Only update when user moves 50+ meters
          timeLimit: 2.minutes,
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
          );
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

  bool _isNonRetryableError(Object error) {
    final errorMessage = error.toString().toLowerCase();
    return errorMessage.contains('permission') ||
        errorMessage.contains('service') ||
        errorMessage.contains('disabled');
  }
}
