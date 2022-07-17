import 'package:injectable/injectable.dart';
import 'package:{{#snakeCase}}{{project_name}}{{/snakeCase}}/router/router.dart';
import 'package:stash/stash_api.dart';
import 'package:stash_objectbox/stash_objectbox.dart';

@module
abstract class InjectableModule {
  @lazySingleton
  AppRouter get router => AppRouter();

  @preResolve
  Future<Store<CacheInfo, CacheEntry>> get store {
    return newObjectboxLocalCacheStore();
  }
}
