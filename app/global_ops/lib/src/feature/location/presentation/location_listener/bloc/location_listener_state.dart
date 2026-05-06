import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/location/domain/domain.dart';

abstract class LocationListenerState extends Equatable {
  const LocationListenerState();

  @override
  List<Object?> get props => [];
}

class LocationListenerInitialState extends LocationListenerState {}

class LocationListenerLoadingState extends LocationListenerState {}

class LocationListenerLoadedState extends LocationListenerState {
  const LocationListenerLoadedState(this.location, {this.isStale = false});

  final LocationEntity location;
  final bool
  isStale; // Indicates if this is a cached location due to GPS timeout

  @override
  List<Object?> get props => [location, isStale];
}

class LocationListenerFailureState extends LocationListenerState {
  const LocationListenerFailureState(this.error, {this.errorType});

  final Object error;
  final LocationErrorType? errorType;

  @override
  List<Object?> get props => [error, errorType];
}

enum LocationErrorType {
  permissionDenied,
  serviceDisabled,
  networkError,
  timeout,
  unknown,
}
