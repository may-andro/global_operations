import 'dart:async';

import 'package:core/core.dart';
import 'package:global_ops/src/feature/feature_toggle/domain/repository/feature_flag_repository.dart';

class BuildFeatureFlagRepository implements FeatureFlagRepository {
  BuildFeatureFlagRepository(
    BuildConfig buildConfig,
    FeatureFlagRepository cacheRepositoryDelegate,
    FeatureFlagRepository remoteRepositoryDelegate,
  ) : _repositoryDelegate = buildConfig.buildEnvironment.isFeatureFlagCached
          ? cacheRepositoryDelegate
          : remoteRepositoryDelegate;

  final FeatureFlagRepository _repositoryDelegate;

  @override
  FutureOr<void> initFeatureFlags() {
    return _repositoryDelegate.initFeatureFlags();
  }

  @override
  FutureOr<bool> isFeatureEnabled(Feature feature) {
    return _repositoryDelegate.isFeatureEnabled(feature);
  }

  @override
  FutureOr<List<FeatureFlag>> getFeatureFlags() {
    return _repositoryDelegate.getFeatureFlags();
  }

  @override
  FutureOr<void> reset() {
    return _repositoryDelegate.reset();
  }

  @override
  void updateFeatureFlag(FeatureFlag featureFlag) {
    return _repositoryDelegate.updateFeatureFlag(featureFlag);
  }
}
