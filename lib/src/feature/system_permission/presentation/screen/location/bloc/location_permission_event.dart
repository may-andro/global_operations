import 'package:equatable/equatable.dart';

abstract class LocationPermissionEvent extends Equatable {
  const LocationPermissionEvent();

  @override
  List<Object?> get props => [];
}

class PermissionCheckRequestedEvent extends LocationPermissionEvent {
  const PermissionCheckRequestedEvent();
}

class PermissionRequestEvent extends LocationPermissionEvent {
  const PermissionRequestEvent();
}
