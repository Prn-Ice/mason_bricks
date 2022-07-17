import 'package:auto_route/auto_route.dart';
import 'package:auto_route_observer/auto_route_observer.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLogger extends Mock implements Logger {}

void main() {
  group('AppRouteObserver', () {
    late Logger logger;
    late AppRouteObserver observer;
    late Route<dynamic> route;
    late TabPageRoute tabRoute;

    setUp(() {
      logger = MockLogger();
      observer = AppRouteObserver(logger: logger);
      route = MaterialPageRoute<void>(
        builder: (context) => Container(),
        settings: const RouteSettings(name: 'test route'),
      );
      tabRoute = const TabPageRoute(
        index: 0,
        routeInfo: RouteMatch<void>(
          name: 'test tab route',
          segments: [],
          stringMatch: 'test',
          path: 'test',
          key: ValueKey<String>('test value'),
        ),
      );
    });

    test('can be instantiated', () {
      expect(AppRouteObserver(), isNotNull);
    });

    group('didPush', () {
      test('calls loggy.info', () {
        observer.didPush(route, route);

        verify(() => logger.v('New route pushed: ${route.settings.name}'));
      });
    });

    group('didInitTabRoute', () {
      test('calls loggy.info', () {
        observer.didInitTabRoute(tabRoute, tabRoute);

        verify(() => logger.v('Tab route visited: ${tabRoute.name}'));
      });
    });

    group('didChangeTabRoute', () {
      test('calls loggy.info', () {
        observer.didChangeTabRoute(tabRoute, tabRoute);

        verify(() => logger.v('Tab route re-visited: ${tabRoute.name}'));
      });
    });
  });
}
