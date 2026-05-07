import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:remote/src/rest/dio_exception_extension.dart';
import 'package:remote/src/rest/rest_api_service.dart';

class DioApiService implements RestApiService {
  DioApiService(this._dio);

  final Dio _dio;

  @override
  Future<T?> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return _decode<T>(response.data);
    } catch (error) {
      if (error is DioException) {
        throw error.remoteApiException;
      } else {
        rethrow;
      }
    }
  }

  @override
  Future<T?> post<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.post<dynamic>(
        path,
        queryParameters: queryParameters,
      );
      return _decode<T>(response.data);
    } catch (error) {
      if (error is DioException) {
        throw error.remoteApiException;
      } else {
        rethrow;
      }
    }
  }

  /// Safely coerces [data] to [T].
  /// If Dio did not auto-parse the body (i.e. it's still a raw JSON string),
  /// this decodes it before casting.
  T? _decode<T>(dynamic data) {
    if (data == null) return null;
    if (data is T) return data;
    if (data is String) {
      final decoded = jsonDecode(data);
      return decoded as T?;
    }
    return data as T?;
  }
}
