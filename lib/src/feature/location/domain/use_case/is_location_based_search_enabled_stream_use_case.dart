import 'dart:async';

import 'package:global_ops/src/feature/location/domain/repository/repository.dart';

class IsLocationBasedSearchEnabledStreamUseCase {
  IsLocationBasedSearchEnabledStreamUseCase(this._repository);

  final LocationRepository _repository;

  Stream<bool?> call() {
    return _repository.isLocationBasedSearchEnabledStream;
  }
}
