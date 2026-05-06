import 'dart:async';

import 'package:global_ops/src/feature/system_permission/domain/entity/entity.dart';
import 'package:global_ops/src/feature/system_permission/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class RequestPermissionFailure extends BasicFailure {
  const RequestPermissionFailure({super.message, super.cause});
}

class RequestPermissionParams {
  const RequestPermissionParams({
    required this.permission,
    this.isProvisional = false,
  });

  final PermissionEntity permission;
  final bool isProvisional;
}

class RequestPermissionUseCase
    extends
        BaseUseCase<
          PermissionStatusEntity,
          RequestPermissionParams,
          RequestPermissionFailure
        > {
  RequestPermissionUseCase(this._permissionRepository);

  final PermissionRepository _permissionRepository;

  @override
  @protected
  FutureOr<Either<RequestPermissionFailure, PermissionStatusEntity>> execute(
    RequestPermissionParams input,
  ) async {
    final status = await _permissionRepository.requestPermission(
      input.permission,
      isProvisional: input.isProvisional,
    );

    return Right(status);
  }

  @override
  RequestPermissionFailure mapErrorToFailure(Object e, StackTrace st) {
    return RequestPermissionFailure(message: e.toString(), cause: st);
  }
}
