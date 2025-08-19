import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/location/domain/domain.dart';

abstract class LocationListenerEvent extends Equatable {
  const LocationListenerEvent();

  @override
  List<Object?> get props => [];
}

class StartTrackingLocationEvent extends LocationListenerEvent {
  const StartTrackingLocationEvent({
    this.timeout = const Duration(seconds: 30),
    this.maxRetries = 3,
  });

  final Duration timeout;
  final int maxRetries;

  @override
  List<Object?> get props => [timeout, maxRetries];
}

class StopTrackingLocationEvent extends LocationListenerEvent {}

class RetryLocationEvent extends LocationListenerEvent {
  const RetryLocationEvent();

  @override
  List<Object?> get props => [];
}

// Internal events for updating state
class _LocationUpdatedEvent extends LocationListenerEvent {
  const _LocationUpdatedEvent(this.location);

  final LocationEntity location;

  @override
  List<Object?> get props => [location];
}

class _LocationErrorEvent extends LocationListenerEvent {
  const _LocationErrorEvent(this.error);

  final Object error;

  @override
  List<Object?> get props => [error];
}
