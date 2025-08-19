import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:global_ops/src/feature/system_permission/domain/domain.dart';
import 'package:global_ops/src/feature/system_permission/presentation/screen/location/bloc/location_permission_event.dart';
import 'package:global_ops/src/feature/system_permission/presentation/screen/location/bloc/location_permission_state.dart';

class LocationPermissionBloc
    extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  LocationPermissionBloc(
    this._getPermissionStatusUseCase,
    this._requestPermissionUseCase,
  ) : super(const LocationPermissionInitialState()) {
    on<PermissionCheckRequestedEvent>(_mapPermissionCheckRequestedEventToState);
    on<PermissionRequestEvent>(_mapPermissionRequestEventToState);
  }

  final GetPermissionStatusUseCase _getPermissionStatusUseCase;
  final RequestPermissionUseCase _requestPermissionUseCase;

  Future<void> _mapPermissionCheckRequestedEventToState(
    PermissionCheckRequestedEvent event,
    Emitter<LocationPermissionState> emit,
  ) async {
    final result = await _getPermissionStatusUseCase(PermissionEntity.location);
    result.fold(
      (failure) => emit(const LocationPermissionFailureState()),
      (status) => emit(LocationPermissionStatusChangedState(status)),
    );
  }

  Future<void> _mapPermissionRequestEventToState(
    PermissionRequestEvent event,
    Emitter<LocationPermissionState> emit,
  ) async {
    final result = await _requestPermissionUseCase(
      const RequestPermissionParams(permission: PermissionEntity.location),
    );
    result.fold(
      (failure) => emit(const LocationPermissionFailureState()),
      (status) => emit(LocationPermissionStatusChangedState(status)),
    );
  }
}
