import 'dart:async';

import 'package:global_ops/src/feature/system_permission/domain/entity/entity.dart';
import 'package:global_ops/src/feature/system_permission/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class GetPermissionStatusFailure extends BasicFailure {
  const GetPermissionStatusFailure({super.message, super.cause});
}

class GetPermissionStatusUseCase
    extends
        BaseUseCase<
          PermissionStatusEntity,
          PermissionEntity,
          GetPermissionStatusFailure
        > {
  GetPermissionStatusUseCase(this._permissionRepository);

  final PermissionRepository _permissionRepository;

  @override
  @protected
  FutureOr<Either<GetPermissionStatusFailure, PermissionStatusEntity>> execute(
    PermissionEntity input,
  ) async {
    final status = await _permissionRepository.getPermissionStatus(input);
    return Right(status);
  }

  @override
  GetPermissionStatusFailure mapErrorToFailure(Object e, StackTrace st) {
    return GetPermissionStatusFailure(message: e.toString(), cause: st);
  }
}
