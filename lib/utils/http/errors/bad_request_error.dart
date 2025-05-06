import 'dart:collection';

import 'package:dio/dio.dart';

class BadRequestError extends DioException {
  Map<String, dynamic> errors = HashMap();

  /// Creates a bad request error with the given error data
  BadRequestError(this.errors) 
      : super(
          requestOptions: RequestOptions(path: ''),
          message: 'Bad Request Error',
          type: DioExceptionType.badResponse,
        );

  /// Creates a bad request error from an existing DioException
  BadRequestError.fromError(DioException error, this.errors)
      : super(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: error.error,
          message: error.message ?? 'Bad Request Error',
          stackTrace: error.stackTrace,
        );

  /// Gets a generic error message, looking first for '__all__' then 'non_field_errors'
  String? generic() {
    return key('__all__') ?? key('non_field_errors');
  }

  /// Gets the error message for a specific field key
  String? key(String key) {
    if (errors.containsKey(key)) {
      final error = errors[key];
      if (error is List && error.isNotEmpty) {
        return error[0]?.toString();
      } else {
        return error?.toString();
      }
    }
    return null;
  }

  /// Gets a field error or falls back to a generic error
  String? fieldOrGeneric(String fieldName) {
    return key(fieldName) ?? generic();
  }
}