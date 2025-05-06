import 'package:dio/dio.dart';

class UnauthorizedError extends DioException {
  /// Creates an unauthorized error with a default message
  UnauthorizedError({
    String message = 'Unauthorized request',
    RequestOptions? requestOptions,
    Response? response,
    DioExceptionType type = DioExceptionType.badResponse,
    dynamic error,
  }) : super(
          requestOptions: requestOptions ?? RequestOptions(path: ''),
          response: response,
          type: type,
          error: error,
          message: message,
        );

  /// Creates an unauthorized error from an existing DioException
  UnauthorizedError.fromError(DioException error)
      : super(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: error.error,
          message: error.message ?? 'Unauthorized request',
          stackTrace: error.stackTrace,
        );
}