/// Configuration constants for proximity ad panels
class ProximityAdPanelsConfig {
  const ProximityAdPanelsConfig._();

  /// Default search radius in kilometers
  static const double defaultSearchRadius = 5.0;

  /// Minimum radius change threshold for location updates (in km)
  static const double minLocationChangeThreshold = 0.1;

  /// Default debounce duration for search queries
  static const Duration searchDebounceDelay = Duration(milliseconds: 500);

  /// Maximum retry attempts for failed requests
  static const int maxRetryAttempts = 3;

  /// Default page size for pagination
  static const int defaultPageSize = 20;
}
