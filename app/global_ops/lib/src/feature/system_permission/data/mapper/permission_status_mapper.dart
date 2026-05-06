import 'package:core/core.dart';
import 'package:global_ops/src/feature/system_permission/domain/domain.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionStatusMapper
    implements BiMapper<PermissionStatus, PermissionStatusEntity> {
  @override
  PermissionStatus from(PermissionStatusEntity from) {
    switch (from) {
      case PermissionStatusEntity.granted:
        return PermissionStatus.granted;
      case PermissionStatusEntity.denied:
        return PermissionStatus.denied;
      case PermissionStatusEntity.restricted:
        return PermissionStatus.restricted;
      case PermissionStatusEntity.permanentlyDenied:
        return PermissionStatus.permanentlyDenied;
      case PermissionStatusEntity.limited:
        return PermissionStatus.limited;
      case PermissionStatusEntity.provisional:
        return PermissionStatus.provisional;
    }
  }

  @override
  PermissionStatusEntity to(PermissionStatus from) {
    switch (from) {
      case PermissionStatus.granted:
        return PermissionStatusEntity.granted;
      case PermissionStatus.denied:
        return PermissionStatusEntity.denied;
      case PermissionStatus.restricted:
        return PermissionStatusEntity.restricted;
      case PermissionStatus.permanentlyDenied:
        return PermissionStatusEntity.permanentlyDenied;
      case PermissionStatus.limited:
        return PermissionStatusEntity.limited;
      case PermissionStatus.provisional:
        return PermissionStatusEntity.provisional;
    }
  }
}
