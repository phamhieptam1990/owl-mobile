import 'package:flutter/material.dart';

class ContextUtils {
  /// Safely executes a function that requires a BuildContext, only if context is not null
  static void safelyExecute(BuildContext? context, Function(BuildContext) function) {
    if (context != null) {
      function(context);
    }
  }
  
  /// Safely gets text from a localization if context is not null, returns fallback otherwise
  static String safelyGetLocalizedText(BuildContext? context, String Function(BuildContext) textGetter, String fallback) {
    if (context != null) {
      return textGetter(context);
    }
    return fallback;
  }
}
