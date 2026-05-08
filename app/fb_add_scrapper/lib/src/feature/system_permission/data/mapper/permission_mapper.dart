import 'package:core/core.dart';
import 'package:fb_add_scrapper/src/feature/system_permission/domain/domain.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionMapper implements BiMapper<Permission, PermissionEntity> {
  @override
  Permission from(PermissionEntity from) {
    return Permission.notification;
  }

  @override
  PermissionEntity to(Permission from) {
    switch (from) {
      case Permission.notification:
        return PermissionEntity.notification;
      default:
        throw ArgumentError('Unknown permission: $from');
    }
  }
}
