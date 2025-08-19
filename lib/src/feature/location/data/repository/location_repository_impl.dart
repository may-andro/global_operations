import 'dart:async';

import 'package:global_ops/src/feature/location/data/cache/location_based_search_cache.dart';
import 'package:global_ops/src/feature/location/domain/domain.dart';

class LocationRepositoryImpl implements LocationRepository {
  LocationRepositoryImpl(this._locationBasedSearchCache) {
    _initStream();
  }

  final LocationBasedSearchCache _locationBasedSearchCache;
  final StreamController<bool?> _controller =
      StreamController<bool?>.broadcast();

  Future<void> _initStream() async {
    final initial = await isLocationBasedSearchEnabled();
    _controller.add(initial ?? true);
  }

  @override
  Future<bool?> isLocationBasedSearchEnabled() {
    return _locationBasedSearchCache.get();
  }

  @override
  Stream<bool?> get isLocationBasedSearchEnabledStream async* {
    // Emit the initial value first
    yield await isLocationBasedSearchEnabled() ?? true;
    // Then emit all subsequent values from the controller
    yield* _controller.stream;
  }

  @override
  Future<bool> updateLocationBasedSearchEnabled(bool isEnabled) async {
    final result = await _locationBasedSearchCache.put(isEnabled);
    _controller.add(isEnabled);
    return result;
  }
}
