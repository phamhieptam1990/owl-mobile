import 'package:dio/dio.dart';
import 'package:athena/utils/http/errors/unauthorized_error.dart';

import '../errors/bad_request_error.dart';

class BadRequestInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Return early if we encounter an UnauthorizedError
    if (err is UnauthorizedError) {
      handler.next(err);
      return;
    }
    
    // Check if response exists and handle errors based on status codes
    if (err.response != null) {
      final statusCode = err.response?.statusCode;
      
      // Handle 400 Bad Request errors
      if (statusCode == 400) {
        final errorData = err.response?.data ?? {};
        final badRequestError = BadRequestError(errorData);
        handler.reject(badRequestError);
        return;
      } 
      // Handle 417 Expectation Failed errors
      else if (statusCode == 417) {
        final badRequestError = BadRequestError({});
        handler.reject(badRequestError);
        return;
      }
    }
    
    // For other errors, continue with the error handling chain
    handler.next(err);
  }
}