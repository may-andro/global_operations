abstract class LocationRepository {
  Future<bool?> isLocationBasedSearchEnabled();

  Stream<bool?> get isLocationBasedSearchEnabledStream;

  Future<bool> updateLocationBasedSearchEnabled(bool isEnabled);
}
