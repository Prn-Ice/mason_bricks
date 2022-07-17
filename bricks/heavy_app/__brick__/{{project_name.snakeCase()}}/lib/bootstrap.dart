// Copyright (c) {{current_year}}, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_logger/bloc_logger.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:{{project_name.snakeCase()}}/injection/injection.dart';
import 'package:{{project_name.snakeCase()}}/utils/utils.dart';

Future<void> bootstrap(FutureOr<Widget> Function() builder) async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Keep splash open
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // setup GetIt
  configureDependencies();

  // close splash
  FlutterNativeSplash.remove();

  // setup logger
  final blocLogger = getLogger('BLOC', usePrettyPrinter: true);
  final globalLogger = getLogger('GLOBAL');

  FlutterError.onError = (details) {
    globalLogger.e(
      details.exceptionAsString(),
      details.exception,
      details.stack,
    );
  };

  await runZonedGuarded(
    () async {
      await BlocOverrides.runZoned(
        () async => runApp(await builder()),
        blocObserver: LoggerBlocObserver(logger: blocLogger),
      );
    },
    (error, stackTrace) => globalLogger.e(error.toString(), error, stackTrace),
  );
}
