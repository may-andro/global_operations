import 'package:core/core.dart';
import 'package:fb_add_scrapper/src/feature/feature_toggle/data/model/feature_model.dart';

class FeatureFlagMapper implements Mapper<FeatureFlag, FeatureModel> {
  @override
  FeatureModel map(FeatureFlag from) {
    return FeatureModel(
      name: from.feature.key,
      isEnabled: from.isEnabled ? 1 : 0,
    );
  }
}
