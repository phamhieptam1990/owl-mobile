import 'package:dio/dio.dart';

class InternalServerError extends DioException {
  /// Creates an internal server error with a default message
  InternalServerError({
    String message = 'Internal Server Error',
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

  /// Creates an internal server error from an existing DioException
  InternalServerError.fromError(DioException error)
      : super(
          requestOptions: error.requestOptions,
          response: error.response,
          type: error.type,
          error: error.error,
          message: error.message ?? 'Internal Server Error',
          stackTrace: error.stackTrace,
        );
}