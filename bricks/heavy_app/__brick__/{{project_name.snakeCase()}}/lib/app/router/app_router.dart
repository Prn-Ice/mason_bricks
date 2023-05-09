import 'package:auto_route/auto_route.dart';
import 'app_router.gr.dart';

@AutoRouterConfig(
  replaceInRouteName: 'Page,Route',
)
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType {
    return const RouteType.custom(
      transitionsBuilder: TransitionsBuilders.fadeIn,
    );
  }

  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: CounterRoute.page),
  ];
}
