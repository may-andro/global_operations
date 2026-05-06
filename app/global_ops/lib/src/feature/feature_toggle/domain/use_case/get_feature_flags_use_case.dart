import 'dart:async';

import 'package:core/core.dart';
import 'package:global_ops/src/feature/feature_toggle/domain/repository/feature_flag_repository.dart';
import 'package:use_case/use_case.dart';

class FeatureFlagFetchFailure extends BasicFailure {
  const FeatureFlagFetchFailure({super.message, super.cause});
}

class GetFeatureFlagsUseCase
    extends BaseNoParamUseCase<List<FeatureFlag>, FeatureFlagFetchFailure> {
  GetFeatureFlagsUseCase(this._featureFlagRepository);

  final FeatureFlagRepository _featureFlagRepository;

  @override
  FutureOr<Either<FeatureFlagFetchFailure, List<FeatureFlag>>> execute() async {
    final featureFlags = await _featureFlagRepository.getFeatureFlags();
    return Right(featureFlags);
  }

  @override
  FeatureFlagFetchFailure mapErrorToFailure(Object e, StackTrace st) {
    return FeatureFlagFetchFailure(message: e.toString(), cause: e);
  }
}
