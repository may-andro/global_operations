import 'package:error_reporter/error_reporter.dart';

class DateTimeValidationException implements AppException {
  DateTimeValidationException(this.cause);

  final Object cause;

  @override
  String toString() {
    return 'DateTimeValidationException: The date time validation failed';
  }
}
