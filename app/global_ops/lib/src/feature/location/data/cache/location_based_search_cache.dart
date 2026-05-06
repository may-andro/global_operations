import 'package:cache/cache.dart';

class LocationBasedSearchCache extends KeyValueCache<bool> {
  LocationBasedSearchCache() : super('location_based_search');

  @override
  bool deserializeValue(Map<String, dynamic> map) {
    return map['location_based_search'] as bool;
  }

  @override
  Map<String, dynamic> serializeValue(bool value) {
    return {'location_based_search': value};
  }
}
