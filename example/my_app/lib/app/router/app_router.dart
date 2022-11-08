import 'package:auto_route/auto_route.dart';
import 'package:my_app/features/counter/counter.dart';

@CustomAutoRouter(
  replaceInRouteName: 'Page,Route',
  transitionsBuilder: TransitionsBuilders.fadeIn,
  routes: <AutoRoute>[
    AutoRoute<void>(page: CounterPage),
  ],
)
class $AppRouter {}
