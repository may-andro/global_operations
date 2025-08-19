import 'package:global_ops/src/feature/system_permission/data/mapper/mapper.dart';
import 'package:global_ops/src/feature/system_permission/domain/domain.dart';
import 'package:log_reporter/log_reporter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:synchronized/synchronized.dart';

class PermissionRepositoryImpl implements PermissionRepository {
  PermissionRepositoryImpl(
    this._permissionMapper,
    this._permissionStatusMapper,
    this._logReporter,
  );

  final PermissionMapper _permissionMapper;
  final PermissionStatusMapper _permissionStatusMapper;
  final LogReporter _logReporter;

  final Lock _lock = Lock();

  @override
  Future<PermissionStatusEntity> getPermissionStatus(
    PermissionEntity permission,
  ) {
    return _lock.synchronized(() async {
      _logReporter.debug(
        tag: 'PermissionRepositoryImpl',
        'Starting to get status for ${permission.name}',
      );
      try {
        final status = await _permissionMapper.from(permission).status;
        return _permissionStatusMapper.to(status);
      } finally {
        _logReporter.debug(
          tag: 'PermissionRepositoryImpl',
          'Ended getting status for ${permission.name}',
        );
      }
    });
  }

  @override
  Future<PermissionStatusEntity> requestPermission(
    PermissionEntity permission, {
    bool isProvisional = false,
  }) {
    return _lock.synchronized(() async {
      _logReporter.debug('Starting to request ${permission.name}');
      try {
        final status = await _permissionMapper.from(permission).request();
        return _permissionStatusMapper.to(status);
      } finally {
        _logReporter.debug('Ended requesting ${permission.name}');
      }
    });
  }
}
