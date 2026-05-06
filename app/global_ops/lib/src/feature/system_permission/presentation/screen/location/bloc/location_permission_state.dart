import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/system_permission/domain/domain.dart';

abstract class LocationPermissionState extends Equatable {
  const LocationPermissionState();

  @override
  List<Object?> get props => [];
}

class LocationPermissionInitialState extends LocationPermissionState {
  const LocationPermissionInitialState();
}

class LocationPermissionStatusChangedState extends LocationPermissionState {
  const LocationPermissionStatusChangedState(this.status);

  final PermissionStatusEntity status;

  @override
  List<Object?> get props => [status];
}

class LocationPermissionFailureState extends LocationPermissionState {
  const LocationPermissionFailureState();
}
