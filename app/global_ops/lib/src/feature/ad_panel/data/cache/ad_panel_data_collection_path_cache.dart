import 'package:cache/cache.dart';
import 'package:core/core.dart';

class AdPanelDataCollectionPathCache extends KeyValueCache<String> {
  AdPanelDataCollectionPathCache()
    : super('ad_panel_data_collection_path_cache');

  @override
  String deserializeValue(Map<String, dynamic> map) {
    return map['collectionPath'] as String;
  }

  @override
  Map<String, dynamic> serializeValue(String value) {
    return {'collectionPath': value};
  }

  @override
  Duration get timeToLive => 2.days;
}
