import 'package:tracking/tracking.dart';

class _TrackingArea extends TrackingArea {
  const _TrackingArea() : super('feature_toggle');
}

class FeatureToggleTrackingDelegate extends ScreenTrackingDelegate {
  FeatureToggleTrackingDelegate(TrackingReporter trackingReporter)
    : super(const _TrackingArea(), trackingReporter);
}
