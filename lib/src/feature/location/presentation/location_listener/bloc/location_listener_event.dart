import 'package:equatable/equatable.dart';

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
