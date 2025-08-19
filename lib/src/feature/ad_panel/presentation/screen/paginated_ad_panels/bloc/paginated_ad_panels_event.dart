import 'package:equatable/equatable.dart';
import 'package:global_ops/src/feature/ad_panel/presentation/screen/ad_panels/dto/dto.dart';

/// Base class for all ad panels events
sealed class PaginatedAdPanelsEvent extends Equatable {
  const PaginatedAdPanelsEvent();

  @override
  List<Object?> get props => [];
}

/// Event to load ad panels
final class LoadAdPanelsEvent extends PaginatedAdPanelsEvent {
  const LoadAdPanelsEvent();
}

/// Event to load next page of ad panels
final class LoadMoreAdPanelsEvent extends PaginatedAdPanelsEvent {
  const LoadMoreAdPanelsEvent();
}

/// Event to refresh ad panels
final class RefreshAdPanelsEvent extends PaginatedAdPanelsEvent {
  const RefreshAdPanelsEvent();
}

/// Event to update search query
final class UpdateSearchQueryEvent extends PaginatedAdPanelsEvent {
  const UpdateSearchQueryEvent(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

final class ClearAdPanelsFiltersEvent extends PaginatedAdPanelsEvent {
  const ClearAdPanelsFiltersEvent();
}

/// Event to retry loading after error
final class RetryLoadAdPanelsEvent extends PaginatedAdPanelsEvent {
  const RetryLoadAdPanelsEvent();
}

/// Event to set view type (list or map)
final class SetAdPanelsViewTypeEvent extends PaginatedAdPanelsEvent {
  const SetAdPanelsViewTypeEvent(this.viewType);

  final AdPanelViewType viewType;

  @override
  List<Object?> get props => [viewType];
}

/// Event to update sort option
final class UpdateSortOptionEvent extends PaginatedAdPanelsEvent {
  const UpdateSortOptionEvent(this.sortOption);

  final AdPanelSortOption sortOption;

  @override
  List<Object?> get props => [sortOption];
}
