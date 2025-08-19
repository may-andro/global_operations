import 'dart:collection';
import 'package:global_ops/src/feature/location/domain/entity/location_entity.dart';

class LocationHistory {
  LocationHistory({this.maxSize = 50});

  final int maxSize;
  final Queue<LocationHistoryEntry> _history = Queue<LocationHistoryEntry>();

  void addLocation(LocationEntity location) {
    _history.addLast(
      LocationHistoryEntry(location: location, timestamp: DateTime.now()),
    );

    // Keep only the most recent locations
    while (_history.length > maxSize) {
      _history.removeFirst();
    }
  }

  List<LocationHistoryEntry> get history => _history.toList();

  LocationEntity? get lastLocation =>
      _history.isNotEmpty ? _history.last.location : null;

  double? get averageAccuracy {
    if (_history.isEmpty) return null;

    final totalAccuracy = _history.fold<double>(
      0,
      (sum, entry) => sum + (entry.location.accuracyInM ?? 0),
    );

    return totalAccuracy / _history.length;
  }

  void clear() => _history.clear();

  bool get isEmpty => _history.isEmpty;
  bool get isNotEmpty => _history.isNotEmpty;
}

class LocationHistoryEntry {
  const LocationHistoryEntry({required this.location, required this.timestamp});

  final LocationEntity location;
  final DateTime timestamp;
}
