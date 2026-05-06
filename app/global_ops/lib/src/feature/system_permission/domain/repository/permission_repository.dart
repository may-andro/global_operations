import 'package:global_ops/src/feature/system_permission/domain/entity/entity.dart';

abstract class PermissionRepository {
  Future<PermissionStatusEntity> requestPermission(
    PermissionEntity permission, {
    bool isProvisional = false,
  });

  Future<PermissionStatusEntity> getPermissionStatus(
    PermissionEntity permission,
  );
}
