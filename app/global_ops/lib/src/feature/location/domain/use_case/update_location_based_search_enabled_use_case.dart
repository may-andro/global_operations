import 'dart:async';

import 'package:global_ops/src/feature/location/domain/repository/repository.dart';
import 'package:meta/meta.dart';
import 'package:use_case/use_case.dart';

class UpdateLocationBasedSearchEnabledUseCase
    extends BaseUseCase<void, bool, NoFailure> {
  UpdateLocationBasedSearchEnabledUseCase(this._repository);

  final LocationRepository _repository;

  @override
  @protected
  FutureOr<Either<NoFailure, void>> execute(bool input) async {
    await _repository.updateLocationBasedSearchEnabled(input);

    return const Right(null);
  }

  @override
  NoFailure mapErrorToFailure(Object e, StackTrace st) {
    return NoFailure();
  }
}
