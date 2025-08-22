import 'dart:math' as math;

import 'package:global_ops/src/feature/ad_panel/domain/domain.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/proximity_ad_panels/bloc/proximity_ad_panels_exceptions.dart';
import 'package:global_ops/src/feature/location/location.dart';

/// Utility mixin for ad panels business logic operations
mixin AdPanelsBusinessLogic {
  /// Groups ad panels by their object number
  Map<String, List<AdPanelEntity>> groupPanelsByObjectNumber(
    List<AdPanelEntity> panels,
  ) {
    final map = <String, List<AdPanelEntity>>{};
    for (final panel in panels) {
      map.putIfAbsent(panel.objectNumber, () => []).add(panel);
    }
    return map;
  }

  /// Applies search filters to the ad panels map
  Map<String, List<AdPanelEntity>> applySearchFilter(
    Map<String, List<AdPanelEntity>> adPanelsMap,
    String searchQuery,
  ) {
    if (searchQuery.isEmpty) return adPanelsMap;

    final query = searchQuery.toLowerCase().trim();
    final filtered = <String, List<AdPanelEntity>>{};

    adPanelsMap.forEach((key, panels) {
      final filteredPanels = panels.where((panel) {
        return panel.objectNumber.toLowerCase().contains(query) ||
            panel.street.toLowerCase().contains(query);
      }).toList();

      if (filteredPanels.isNotEmpty) {
        filtered[key] = filteredPanels;
      }
    });

    return filtered;
  }

  /// Sorts ad panels map based on the provided sort option
  Map<String, List<AdPanelEntity>> sortPanelsMap(
    Map<String, List<AdPanelEntity>> panelsMap,
    AdPanelSortOption sortOption,
  ) {
    final entries = panelsMap.entries.toList();

    switch (sortOption) {
      case final DistanceSortOption _:
        entries.sort(
          (a, b) =>
              a.value.first.distanceInKm.compareTo(b.value.first.distanceInKm),
        );
      case final StreetSortOption _:
        entries.sort(
          (a, b) => a.value.first.street.compareTo(b.value.first.street),
        );
      case final ObjectNumberSortOption _:
        entries.sort(
          (a, b) =>
              a.value.first.objectNumber.compareTo(b.value.first.objectNumber),
        );
      case final LastEditedSortOption _:
        entries.sort((a, b) {
          final aEdited = a.value.any((panel) => panel.hasBeenEdited);
          final bEdited = b.value.any((panel) => panel.hasBeenEdited);
          if (aEdited == bEdited) {
            return a.value.first.objectNumber.compareTo(
              b.value.first.objectNumber,
            );
          }
          return aEdited ? -1 : 1;
        });
    }

    return {for (final entry in entries) entry.key: entry.value};
  }

  /// Merges two ad panels maps, avoiding duplicates
  Map<String, List<AdPanelEntity>> mergeAdPanelsMaps(
    Map<String, List<AdPanelEntity>> existingMap,
    Map<String, List<AdPanelEntity>> newMap,
  ) {
    final mergedMap = <String, List<AdPanelEntity>>{};

    // Start with existing items
    existingMap.forEach((objectNumber, panels) {
      mergedMap[objectNumber] = List.from(panels);
    });

    // Add new items, avoiding duplicates
    newMap.forEach((objectNumber, newPanels) {
      if (mergedMap.containsKey(objectNumber)) {
        final existingPanels = mergedMap[objectNumber]!;
        final mergedPanels = <AdPanelEntity>[...existingPanels];

        for (final newPanel in newPanels) {
          final exists = existingPanels.any(
            (existing) =>
                existing.key == newPanel.key &&
                existing.objectFaceId == newPanel.objectFaceId,
          );
          if (!exists) {
            mergedPanels.add(newPanel);
          }
        }

        mergedMap[objectNumber] = mergedPanels;
      } else {
        mergedMap[objectNumber] = List.from(newPanels);
      }
    });

    return mergedMap;
  }
}

/// Utility mixin for location and distance calculations
mixin LocationUtilities {
  /// Updates distances for all panels based on current location
  Map<String, List<AdPanelEntity>> updateDistancesForLocation(
    Map<String, List<AdPanelEntity>> panelsMap,
    LocationEntity currentLocation,
    int radialInKm,
  ) {
    final updatedMap = <String, List<AdPanelEntity>>{};

    panelsMap.forEach((objectNumber, panels) {
      final distance = _calculateDistance(
        currentLocation.latitude,
        currentLocation.longitude,
        panels.first.latitude,
        panels.first.longitude,
      );
      if(distance < radialInKm * 1.5) {
        final updatedPanels = panels.map((panel) {
          return panel.copyWith(distanceInKm: distance);
        }).toList();

        updatedMap[objectNumber] = updatedPanels;
      }
    });

    return updatedMap;
  }

  /// Calculates accurate distance using Haversine formula
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
            math.cos(_degreesToRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) => degrees * (math.pi / 180);
}

/// Utility mixin for error handling
mixin ErrorHandling {
  /// Converts various error types to user-friendly exceptions
  ProximityAdPanelsException handleError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('connection')) {
      return const NetworkException(
        'Network error. Please check your connection.',
      );
    } else if (errorString.contains('timeout')) {
      return const TimeoutException('Request timed out. Please try again.');
    } else if (errorString.contains('location')) {
      return const LocationException('Location not available.');
    } else if (errorString.contains('parse') ||
        errorString.contains('format')) {
      return const DataParsingException('Failed to process data.');
    } else {
      return const UnknownException(
        'An unexpected error occurred. Please try again.',
      );
    }
  }

  /// Gets user-friendly error message from exception
  String getErrorMessage(dynamic error) {
    if (error is ProximityAdPanelsException) {
      return error.message;
    }
    return handleError(error).message;
  }
}
