import 'package:core/core.dart';
import 'package:global_ops/src/feature/system_permission/domain/domain.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionMapper implements BiMapper<Permission, PermissionEntity> {
  @override
  Permission from(PermissionEntity from) {
    switch (from) {
      case PermissionEntity.camera:
        return Permission.camera;
      case PermissionEntity.location:
        return Permission.location;
      case PermissionEntity.notification:
        return Permission.notification;
    }
  }

  @override
  PermissionEntity to(Permission from) {
    switch (from) {
      case Permission.camera:
        return PermissionEntity.camera;
      case Permission.location:
        return PermissionEntity.location;
      case Permission.notification:
        return PermissionEntity.notification;
      default:
        throw ArgumentError('Unknown permission: $from');
    }
  }
}
