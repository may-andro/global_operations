import 'dart:async';

import 'package:firebase/firebase.dart';
import 'package:fb_add_scrapper/src/feature/security/domain/domain.dart';
import 'package:log_reporter/log_reporter.dart';
import 'package:ntp/ntp.dart';

class DateTimeSecurityRepositoryImpl implements DateTimeSecurityRepository {
  DateTimeSecurityRepositoryImpl(this._fbFunctionController, this._logReporter);

  final FbFunctionController _fbFunctionController;
  final LogReporter _logReporter;

  final int _thresholdSeconds = 60;
  final httpFallbackUrl = 'https://worldtimeapi.org/api/ip';

  @override
  Future<bool> validateDateTime() async {
    try {
      final deviceTime = DateTime.now().toUtc();
      final referenceTime = await _getReferenceTime();
      final diff = deviceTime.difference(referenceTime).inSeconds;
      return diff.abs() <= _thresholdSeconds;
    } catch (e) {
      throw DateTimeValidationException(e);
    }
  }

  Future<DateTime> _getReferenceTime() async {
    try {
      final ntpTime = await NTP.now();
      return ntpTime.toUtc();
    } catch (e) {
      _logReporter.error('NTP failed: $e', tag: '$runtimeType', error: e);
      try {
        return await _getApiTime();
      } catch (apiError) {
        _logReporter.error(
          'HTTP fallback failed: $apiError',
          tag: '$runtimeType',
          error: apiError,
        );
        rethrow;
      }
    }
  }

  Future<DateTime> _getApiTime() async {
    final response =
        await _fbFunctionController.callFunction('getCurrentServerTime')
            as Map<String, dynamic>?;
    final utcTimeString = response?['utc_datetime'] as String?;
    if (utcTimeString == null) {
      throw DateTimeValidationException(
        'Invalid datetime format from HTTP fallback',
      );
    }
    final apiTime = DateTime.tryParse(utcTimeString)?.toUtc();
    if (apiTime == null) {
      throw DateTimeValidationException(
        'Invalid datetime format from HTTP fallback',
      );
    }
    return apiTime;
  }
}
