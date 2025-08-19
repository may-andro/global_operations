import 'dart:async';

import 'package:global_ops/src/feature/location/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class IsLocationBasedSearchEnabledUseCase
    extends BaseNoParamUseCase<bool, NoFailure> {
  IsLocationBasedSearchEnabledUseCase(this._repository);

  final LocationRepository _repository;

  @override
  @protected
  FutureOr<Either<NoFailure, bool>> execute() async {
    final enabled = await _repository.isLocationBasedSearchEnabled();
    return Right(enabled ?? false);
  }

  @override
  NoFailure mapErrorToFailure(Object e, StackTrace st) {
    return NoFailure();
  }
}
