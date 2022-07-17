// Copyright (c) 2022, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:app_ui/app_ui.dart';
import 'package:auto_route_observer/auto_route_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_app/injection/injection.dart';
import 'package:my_app/l10n/l10n.dart';
import 'package:my_app/router/router.dart';
import 'package:my_app/utils/utils.dart';
import 'package:nil/nil.dart';

class App extends StatelessWidget {
  App({super.key, AppRouter? router}) : _router = router ?? resolve();

  final AppRouter _router;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(414, 896),
      minTextAdapt: true,
      builder: (context, child) => MaterialApp.router(
        routerDelegate: _router.delegate(
          placeholder: (context) => const ColoredBox(color: Colors.white),
          navigatorObservers: () => [
            AppRouteObserver(logger: getLogger('ROUTER')),
          ],
        ),
        routeInformationParser: _router.defaultRouteParser(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        theme: MyAppTheme.standard,
        builder: (context, widget) {
          /// Prevent app from scaling with device font
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
            child: widget ?? const Nil(),
          );
        },
      ),
    );
  }
}
