import 'dart:async';
import 'package:flutter/foundation.dart';

class BackgroundLocationWithTimer {
  /// The timer that periodically triggers the callback
  static Timer? _timer;
  
  /// Status flag indicating whether location monitoring is active
  static bool isListening = false;
  
  /// Starts periodic location monitoring
  /// 
  /// [duration] - The interval between callback executions
  /// [callback] - The function to call at each interval
  static void start({required Duration duration, required VoidCallback callback}) {
    // Stop any existing timer before starting a new one
    if (_timer != null && (_timer?.isActive ?? false)) {
      stop();
    }
    
    isListening = true;
    _timer = Timer.periodic(duration, (timer) {
      callback.call();
    });
  }

  /// Stops the periodic location monitoring
  static void stop() {
    isListening = false;
    _timer?.cancel();
    _timer = null;
  }
  
  /// Pauses the periodic location monitoring without resetting
  static void pause() {
    isListening = false;
    _timer?.cancel();
  }
  
  /// Checks if the timer is currently active
  static bool get isActive => _timer?.isActive ?? false;
}