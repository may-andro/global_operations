import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:global_ops/src/feature/location/domain/entity/entity.dart';
import 'package:global_ops/src/feature/system_permission/system_permission.dart';
import 'package:use_case/use_case.dart';

sealed class GetCurrentLocationFailure extends BasicFailure {
  const GetCurrentLocationFailure({super.message, super.cause});
}

class NoLocationPermissionFailure extends GetCurrentLocationFailure {
  const NoLocationPermissionFailure({super.message, super.cause});
}

class LocationServiceDisabledFailure extends GetCurrentLocationFailure {
  const LocationServiceDisabledFailure({super.message, super.cause});
}

class NoLocationFoundFailure extends GetCurrentLocationFailure {
  const NoLocationFoundFailure({super.message, super.cause});
}

class GetCurrentLocationUseCase
    extends BaseNoParamUseCase<LocationEntity, GetCurrentLocationFailure> {
  GetCurrentLocationUseCase(this._getPermissionStatusUseCase);

  final GetPermissionStatusUseCase _getPermissionStatusUseCase;

  @override
  FutureOr<Either<GetCurrentLocationFailure, LocationEntity>> execute() async {
    // Check if location permission is granted
    final permissionResult = await _getPermissionStatusUseCase.call(
      PermissionEntity.location,
    );
    if (permissionResult.isLeft) {
      final failure = permissionResult.left;
      return Left(
        NoLocationPermissionFailure(
          message: failure.message,
          cause: failure.cause,
        ),
      );
    }
    final permissionStatus = permissionResult.right;
    if (permissionStatus != PermissionStatusEntity.granted) {
      return const Left(
        NoLocationPermissionFailure(message: 'Location permission denied.'),
      );
    }

    // Check if location services are enabled
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const Left(
        LocationServiceDisabledFailure(
          message: 'Location services are disabled.',
        ),
      );
    }

    final position = await Geolocator.getCurrentPosition();
    return Right(
      LocationEntity(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyInM: position.accuracy,
      ),
    );
  }

  @override
  GetCurrentLocationFailure mapErrorToFailure(Object e, StackTrace st) {
    if (e is PermissionDeniedException) {
      return NoLocationPermissionFailure(message: e.toString(), cause: st);
    }
    if (e is LocationServiceDisabledException) {
      return LocationServiceDisabledFailure(message: e.toString(), cause: st);
    }
    if (e is PositionUpdateException) {
      return NoLocationFoundFailure(
        message: 'Position update failed: ${e.message}',
        cause: st,
      );
    }
    return NoLocationFoundFailure(message: e.toString(), cause: st);
  }
}
