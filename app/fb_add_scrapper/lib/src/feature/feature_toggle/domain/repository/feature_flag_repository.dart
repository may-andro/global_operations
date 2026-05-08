import 'dart:async';

import 'package:core/core.dart';

abstract class FeatureFlagRepository {
  FutureOr<void> initFeatureFlags();

  FutureOr<List<FeatureFlag>> getFeatureFlags();

  FutureOr<bool> isFeatureEnabled(Feature feature);

  void updateFeatureFlag(FeatureFlag featureFlag);

  FutureOr<void> reset();
}
