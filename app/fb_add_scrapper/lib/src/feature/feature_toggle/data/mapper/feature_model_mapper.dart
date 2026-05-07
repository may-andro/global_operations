import 'package:core/core.dart';
import 'package:fb_add_scrapper/src/feature/feature_toggle/data/model/feature_model.dart';

class FeatureModelMapper implements Mapper<FeatureModel, FeatureFlag?> {
  @override
  FeatureFlag? map(FeatureModel from) {
    try {
      return FeatureFlag(Feature.getFeature(from.name), from.isEnabled == 1);
    } catch (e) {
      return null;
    }
  }
}
