// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:hive_flutter/hive_flutter.dart' as _i4;
import 'package:hive_service/hive_service.dart' as _i5;
import 'package:injectable/injectable.dart' as _i2;

import '../router/router.dart' as _i3;
import 'module.dart' as _i6; // ignore_for_file: unnecessary_lambdas

// ignore_for_file: lines_longer_than_80_chars
/// initializes the registration of provided dependencies inside of [GetIt]
Future<_i1.GetIt> $initGetIt(
  _i1.GetIt get, {
  String? environment,
  _i2.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i2.GetItHelper(
    get,
    environment,
    environmentFilter,
  );
  final injectableModule = _$InjectableModule();
  gh.lazySingleton<_i3.AppRouter>(() => injectableModule.router);
  await gh.factoryAsync<_i4.Box<dynamic>>(
    () => injectableModule.box(get<_i5.IHiveService>()),
    preResolve: true,
  );
  return get;
}

class _$InjectableModule extends _i6.InjectableModule {}
