import 'dart:async';
import 'package:flutter/foundation.dart';

class Debouncer {
  /// The delay duration before the callback is executed
  final Duration delay;
  
  /// Timer that keeps track of the debounce delay
  Timer? _timer;

  /// Creates a debouncer with a specified delay
  /// 
  /// The default delay is 300 milliseconds if not specified
  Debouncer({this.delay = const Duration(milliseconds: 300)});

  /// Call the function after the specified delay
  /// 
  /// If called again before the delay is completed, the timer resets
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancels any pending timer
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}