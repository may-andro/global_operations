import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

/// Base class for all feature toggle events
sealed class FeatureToggleEvent extends Equatable {
  const FeatureToggleEvent();

  @override
  List<Object> get props => [];
}

// ============================================================================
// DATA LOADING EVENTS
// ============================================================================

final class LoadFFEvent extends FeatureToggleEvent {
  const LoadFFEvent();
}

final class ResetFFEvent extends FeatureToggleEvent {
  const ResetFFEvent();
}

final class UpdateFFEvent extends FeatureToggleEvent {
  const UpdateFFEvent({required this.featureFlag});

  final FeatureFlag featureFlag;

  @override
  List<Object> get props => [featureFlag];
}

// ============================================================================
// FILTERING AND SEARCH EVENTS
// ============================================================================

final class UpdateSearchQueryEvent extends FeatureToggleEvent {
  const UpdateSearchQueryEvent(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

final class ClearSearchQueryEvent extends FeatureToggleEvent {
  const ClearSearchQueryEvent();
}

// ============================================================================
// UI STATE EVENTS
// ============================================================================

final class UpdateListViewTypeEvent extends FeatureToggleEvent {}

// ============================================================================
// NAVIGATION EVENTS
// ============================================================================

final class RestartAppEvent extends FeatureToggleEvent {}

// ============================================================================
// TRACKING EVENTS
// ============================================================================

final class TrackScreenVisibleEvent extends FeatureToggleEvent {}
