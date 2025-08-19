import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/location/domain/domain.dart';
import 'package:global_ops/src/feature/location/presentation/location_listener/bloc/location_listener_event.dart';
import 'package:global_ops/src/feature/location/presentation/location_listener/bloc/location_listener_state.dart';

class LocationListenerBloc
    extends Bloc<LocationListenerEvent, LocationListenerState> {
  LocationListenerBloc(this._trackLocationUseCase)
    : super(LocationListenerInitialState()) {
    on<StartTrackingLocationEvent>(_mapStartTrackingLocationEventToState);
    on<StopTrackingLocationEvent>(_mapStopTrackingLocationEventToState);
    on<RetryLocationEvent>(_onRetryLocation);
    on<_LocationUpdatedEvent>(_onLocationUpdated);
    on<_LocationErrorEvent>(_onLocationError);
  }

  final TrackLocationUseCase _trackLocationUseCase;
  StreamSubscription<LocationEntity>? _subscription;
  Timer? _retryTimer;
  LocationEntity? _lastKnownLocation;
  bool _isRetrying = false;

  void _mapStartTrackingLocationEventToState(
    StartTrackingLocationEvent event,
    Emitter<LocationListenerState> emit,
  ) {
    emit(LocationListenerLoadingState());
    _subscription?.cancel();
    _retryTimer?.cancel();
    _isRetrying = false;

    _subscription =
        _trackLocationUseCase(
          timeout: event.timeout,
          maxRetries: event.maxRetries,
        ).listen(
          (location) {
            _lastKnownLocation = location;
            _isRetrying = false;
            _retryTimer?.cancel();
            add(_LocationUpdatedEvent(location));
          },
          onError: (Object e, StackTrace st) {
            add(_LocationErrorEvent(e));
          },
        );
  }

  void _mapStopTrackingLocationEventToState(
    StopTrackingLocationEvent event,
    Emitter<LocationListenerState> emit,
  ) {
    _subscription?.cancel();
    _retryTimer?.cancel();
    _lastKnownLocation = null;
    _isRetrying = false;
    emit(LocationListenerInitialState());
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _retryTimer?.cancel();
    return super.close();
  }

  void _onLocationUpdated(
    _LocationUpdatedEvent event,
    Emitter<LocationListenerState> emit,
  ) {
    emit(LocationListenerLoadedState(event.location));
  }

  void _onLocationError(
    _LocationErrorEvent event,
    Emitter<LocationListenerState> emit,
  ) {
    final errorType = _categorizeError(event.error);

    // Handle timeout errors gracefully
    if (errorType == LocationErrorType.timeout && _lastKnownLocation != null) {
      // Keep showing the last known location instead of failing completely
      emit(LocationListenerLoadedState(_lastKnownLocation!, isStale: true));

      // Start background retry for timeout errors
      _startBackgroundRetry();
      return;
    }

    // For non-timeout errors or when no last location exists, show error
    emit(LocationListenerFailureState(event.error, errorType: errorType));
  }

  void _startBackgroundRetry() {
    if (_isRetrying) return;

    _isRetrying = true;
    _retryTimer = Timer.periodic(const Duration(seconds: 90), (timer) {
      if (!_isRetrying) {
        timer.cancel();
        return;
      }

      add(const RetryLocationEvent());
    });
  }

  void _onRetryLocation(
    RetryLocationEvent event,
    Emitter<LocationListenerState> emit,
  ) {
    // Attempt to get a fresh location update
    _subscription?.cancel();
    _subscription =
        _trackLocationUseCase(
          timeout: const Duration(seconds: 15), // Shorter timeout for retries
          maxRetries: 1,
        ).listen(
          (location) {
            _lastKnownLocation = location;
            _isRetrying = false;
            _retryTimer?.cancel();
            add(_LocationUpdatedEvent(location));
          },
          onError: (Object e, StackTrace st) {
            // Don't emit error for retry failures, just continue with stale location
            // The retry timer will try again
          },
        );
  }

  LocationErrorType _categorizeError(Object error) {
    final errorMessage = error.toString().toLowerCase();

    if (errorMessage.contains('permission')) {
      return LocationErrorType.permissionDenied;
    } else if (errorMessage.contains('service') ||
        errorMessage.contains('disabled')) {
      return LocationErrorType.serviceDisabled;
    } else if (errorMessage.contains('network')) {
      return LocationErrorType.networkError;
    } else if (errorMessage.contains('timeout') ||
        errorMessage.contains('timed out')) {
      return LocationErrorType.timeout;
    } else {
      return LocationErrorType.unknown;
    }
  }
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
