import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';
import 'package:global_ops/src/feature/location/location.dart';

/// Base class for all ad panels events
sealed class ProximityAdPanelsEvent extends Equatable {
  const ProximityAdPanelsEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================================
// DATA LOADING EVENTS
// ============================================================================

/// Event to initially load ad panels for a given location
final class LoadAdPanelsEvent extends ProximityAdPanelsEvent {
  const LoadAdPanelsEvent(this.location);

  final LocationEntity location;

  @override
  List<Object?> get props => [location];
}

/// Event to refresh/reload ad panels data
final class RefreshAdPanelsEvent extends ProximityAdPanelsEvent {
  const RefreshAdPanelsEvent();
}

/// Event to retry loading after an error occurred
final class RetryLoadAdPanelsEvent extends ProximityAdPanelsEvent {
  const RetryLoadAdPanelsEvent();
}

// ============================================================================
// LOCATION EVENTS
// ============================================================================

/// Event to update ad panels when user location changes (background update)
final class UpdateLocationEvent extends ProximityAdPanelsEvent {
  const UpdateLocationEvent(this.location);

  final LocationEntity location;

  @override
  List<Object?> get props => [location];
}

/// Event to update the search radius for finding ad panels
final class UpdateSearchRadiusEvent extends ProximityAdPanelsEvent {
  const UpdateSearchRadiusEvent(this.radiusInKm);

  final int radiusInKm;

  @override
  List<Object?> get props => [radiusInKm];
}

/// Event to disable location based search and show all ad panels
final class DisableLocationBasedSearchEvent extends ProximityAdPanelsEvent {
  const DisableLocationBasedSearchEvent();
}

// ============================================================================
// FILTERING AND SEARCH EVENTS
// ============================================================================

/// Event to update the search query for filtering ad panels
final class UpdateSearchQueryEvent extends ProximityAdPanelsEvent {
  const UpdateSearchQueryEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Event to clear all applied filters
final class ClearAdPanelsFiltersEvent extends ProximityAdPanelsEvent {
  const ClearAdPanelsFiltersEvent();
}

/// Event to update the sort option for ad panels
final class UpdateSortOptionEvent extends ProximityAdPanelsEvent {
  const UpdateSortOptionEvent(this.sortOption);

  final AdPanelSortOption sortOption;

  @override
  List<Object?> get props => [sortOption];
}

// ============================================================================
// UI STATE EVENTS
// ============================================================================

/// Event to set the view type (list or map view)
final class SetAdPanelsViewTypeEvent extends ProximityAdPanelsEvent {
  const SetAdPanelsViewTypeEvent(this.viewType);

  final AdPanelViewType viewType;

  @override
  List<Object?> get props => [viewType];
}
