import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  CrashlyticsService({
    FirebaseCrashlytics? firebaseCrashlytics,
  }) : _crashlytics = firebaseCrashlytics ?? FirebaseCrashlytics.instance;

  final FirebaseCrashlytics _crashlytics;

  Future<void> recordFlutterFatalError(
    FlutterErrorDetails flutterErrorDetails,
  ) {
    return _crashlytics.recordFlutterFatalError(flutterErrorDetails);
  }

  Future<void> recordError(
    dynamic exception,
    StackTrace? stack,
  ) {
    return FirebaseCrashlytics.instance.recordError(
      exception,
      stack,
      fatal: true,
    );
  }

  Future<void> setUserId(String userId) {
    return _crashlytics.setUserIdentifier(userId);
  }

  Future<void> log(String message) {
    return _crashlytics.log(message);
  }
}
