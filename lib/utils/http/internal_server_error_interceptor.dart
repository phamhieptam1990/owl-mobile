import 'package:dio/dio.dart';

import './errors/internal_server_error.dart';

class InternalServerErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final statusCode = err.response?.statusCode;
      if (statusCode != null && statusCode >= 500 && statusCode < 600) {
        // Create a server error instance
        final serverError = InternalServerError();
        
        // Pass the error to the handler
        handler.reject(serverError);
        return;
      }
    }
    
    // Let the original error continue through the pipeline
    handler.next(err);
  }
}