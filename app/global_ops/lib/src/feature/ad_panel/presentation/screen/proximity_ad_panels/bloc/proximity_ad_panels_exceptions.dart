import 'package:equatable/equatable.dart';

/// Custom exceptions for proximity ad panels operations
abstract class ProximityAdPanelsException extends Equatable
    implements Exception {
  const ProximityAdPanelsException(this.message, [this.code]);

  final String message;
  final String? code;

  @override
  List<Object?> get props => [message, code];
}

/// Exception thrown when network operations fail
class NetworkException extends ProximityAdPanelsException {
  const NetworkException([String? message])
    : super(message ?? 'Network error occurred', 'NETWORK_ERROR');
}

/// Exception thrown when location services are unavailable
class LocationException extends ProximityAdPanelsException {
  const LocationException([String? message])
    : super(message ?? 'Location not available', 'LOCATION_ERROR');
}

/// Exception thrown when requests timeout
class TimeoutException extends ProximityAdPanelsException {
  const TimeoutException([String? message])
    : super(message ?? 'Request timed out', 'TIMEOUT_ERROR');
}

/// Exception thrown when data parsing fails
class DataParsingException extends ProximityAdPanelsException {
  const DataParsingException([String? message])
    : super(message ?? 'Failed to parse data', 'PARSING_ERROR');
}

/// Exception thrown for unexpected errors
class UnknownException extends ProximityAdPanelsException {
  const UnknownException([String? message])
    : super(message ?? 'An unexpected error occurred', 'UNKNOWN_ERROR');
}
