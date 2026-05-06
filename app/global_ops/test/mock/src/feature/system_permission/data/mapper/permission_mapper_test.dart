import 'package:flutter_test/flutter_test.dart';
import 'package:global_ops/src/feature/system_permission/data/mapper/mapper.dart';
import 'package:global_ops/src/feature/system_permission/domain/entity/permission_status_entity.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  group(PermissionStatusMapper, () {
    late PermissionStatusMapper mapper;

    setUp(() {
      mapper = PermissionStatusMapper();
    });

    group('from', () {
      test('should map from PermissionStatusEntity', () {
        expect(
          mapper.from(PermissionStatusEntity.granted),
          PermissionStatus.granted,
        );
        expect(
          mapper.from(PermissionStatusEntity.denied),
          PermissionStatus.denied,
        );
        expect(
          mapper.from(PermissionStatusEntity.restricted),
          PermissionStatus.restricted,
        );
        expect(
          mapper.from(PermissionStatusEntity.permanentlyDenied),
          PermissionStatus.permanentlyDenied,
        );
        expect(
          mapper.from(PermissionStatusEntity.limited),
          PermissionStatus.limited,
        );
        expect(
          mapper.from(PermissionStatusEntity.provisional),
          PermissionStatus.provisional,
        );
      });
    });

    group('to', () {
      test('should map to PermissionStatusEntity', () {
        expect(
          mapper.to(PermissionStatus.granted),
          PermissionStatusEntity.granted,
        );
        expect(
          mapper.to(PermissionStatus.denied),
          PermissionStatusEntity.denied,
        );
        expect(
          mapper.to(PermissionStatus.restricted),
          PermissionStatusEntity.restricted,
        );
        expect(
          mapper.to(PermissionStatus.permanentlyDenied),
          PermissionStatusEntity.permanentlyDenied,
        );
        expect(
          mapper.to(PermissionStatus.limited),
          PermissionStatusEntity.limited,
        );
        expect(
          mapper.to(PermissionStatus.provisional),
          PermissionStatusEntity.provisional,
        );
      });
    });
  });
}
