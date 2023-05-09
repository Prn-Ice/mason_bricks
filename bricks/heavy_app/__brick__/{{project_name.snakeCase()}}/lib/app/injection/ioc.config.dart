// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:crashlytics_service/crashlytics_service.dart' as _i4;
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive_flutter/hive_flutter.dart' as _i6;
import 'package:hive_service/hive_service.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;

import '../router/router.dart' as _i3;
import 'module.dart' as _i7;
import 'service_module.dart' as _i8;

const String _dev = 'dev';
const String _prod = 'prod';

// ignore_for_file: unnecessary_lambdas
// ignore_for_file: lines_longer_than_80_chars
// initializes the registration of main-scope dependencies inside of GetIt
Future<_i1.GetIt> init(
  _i1.GetIt getIt, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final injectableModule = _$InjectableModule();
  final serviceModule = _$ServiceModule();
  gh.lazySingleton<_i3.AppRouter>(() => injectableModule.router);
  gh.lazySingleton<_i4.CrashlyticsService>(
      () => serviceModule.crashlyticsService);
  gh.singleton<_i5.IHiveService>(
    serviceModule.devHiveService,
    registerFor: {_dev},
  );
  gh.singleton<_i5.IHiveService>(
    serviceModule.hiveService,
    registerFor: {_prod},
  );
  await gh.factoryAsync<_i6.Box<dynamic>>(
    () => injectableModule.box(gh<_i5.IHiveService>()),
    preResolve: true,
  );
  return getIt;
}

class _$InjectableModule extends _i7.InjectableModule {}

class _$ServiceModule extends _i8.ServiceModule {}
