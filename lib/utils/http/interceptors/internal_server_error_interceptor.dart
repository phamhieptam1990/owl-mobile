import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/internal_server_error.dart';
import 'dart:io';

class InternalServerErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    try {
      // Handle server errors (5xx)
      if (err.response != null) {
        final statusCode = err.response?.statusCode;
        if (statusCode != null && statusCode >= 500 && statusCode < 600) {
          // Create a custom error for 5xx responses
          final serverError = InternalServerError();
          return handler.reject(serverError);
        }
      }

      // Handle socket exceptions (connectivity issues)
      if (err.error is SocketException) {
        final socketError = err.error as SocketException;
        final errorMessage = socketError.message;
        
        // Check for specific network errors
        if (errorMessage.contains('Failed host lookup')) {
          debugPrint('Network connectivity issue detected: $errorMessage');
          // Add your offline handling code here if needed
        }
        
        // Let the original error continue through the chain
        return handler.next(err);
      }
      
      // For all other errors, continue with the error handling chain
      return handler.next(err);
    } catch (e) {
      debugPrint('Error in InternalServerErrorInterceptor: $e');
      // If something went wrong in our interceptor, still allow the error to propagate
      return handler.next(err);
    }
  }
}