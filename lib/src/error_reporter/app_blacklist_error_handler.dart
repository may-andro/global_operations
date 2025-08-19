import 'package:error_reporter/error_reporter.dart';
import 'package:global_ops/src/error_reporter/blacklist_exception.dart';

class AppBlacklistErrorHandler implements BlacklistErrorHandler {
  @override
  bool isBlacklistError(Object error) {
    return error is BlacklistException;
  }
}
