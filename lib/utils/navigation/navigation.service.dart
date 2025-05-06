import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey;

  // Private constructor for singleton pattern
  NavigationService._() : navigationKey = GlobalKey<NavigatorState>();

  // Singleton instance
  static final NavigationService instance = NavigationService._();

  /// Navigate to a named route and replace current route
  Future<dynamic>? navigateToReplacement(String routeName, {Object? arguments}) {
    return navigationKey.currentState?.pushReplacementNamed(
      routeName, 
      arguments: arguments
    );
  }

  /// Navigate to a named route and remove all previous routes
  Future<dynamic>? pushNamedAndRemoveUntil(String routeName) {
    return navigationKey.currentState?.pushNamedAndRemoveUntil(
      routeName, 
      (Route<dynamic> route) => false
    );
  }

  /// Navigate to a route and remove all previous routes
  Future<dynamic>? pushAndRemoveUntil(MaterialPageRoute<dynamic> route) {
    return navigationKey.currentState?.pushAndRemoveUntil(
      route, 
      (Route<dynamic> route) => false
    );
  }

  /// Navigate to a named route
  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) {
    return navigationKey.currentState?.pushNamed(
      routeName, 
      arguments: arguments
    );
  }

  /// Navigate to a route
  Future<dynamic>? navigateToRoute(MaterialPageRoute<dynamic> route) {
    return navigationKey.currentState?.push(route);
  }

  /// Go back to previous route
  bool? goback({Object? result}) {
    if (navigationKey.currentState?.canPop() == true) {
      navigationKey.currentState?.pop(result);
      return true;
    }
    return false;
  }

  /// Check if can pop
  bool get canPop => navigationKey.currentState?.canPop() ?? false;

  /// Pop until a specific route
  void popUntil(String routeName) {
    navigationKey.currentState?.popUntil(
      (route) => route.settings.name == routeName
    );
  }
}