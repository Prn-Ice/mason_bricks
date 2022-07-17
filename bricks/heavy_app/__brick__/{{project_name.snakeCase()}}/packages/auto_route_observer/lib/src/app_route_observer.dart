import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Observer used with `AutoRouter`, it logs all push and tab change events
/// to console using the `Loggy` package.
class AppRouteObserver extends AutoRouterObserver {
  AppRouteObserver({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logger.v('New route pushed: ${route.settings.name}');
  }

  // only override to observer tab routes
  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    _logger.v('Tab route visited: ${route.name}');
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    _logger.v('Tab route re-visited: ${route.name}');
  }
}
