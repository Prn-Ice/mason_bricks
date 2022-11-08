import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:{{package_name.snakeCase()}}/{{package_name.snakeCase()}}.dart';
import 'package:{{package_name.snakeCase()}}/src/client/{{package_name.snakeCase()}}_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stash/stash_api.dart';

part 'i_{{package_name.snakeCase()}}.dart';

/// {@template {{{package_name.snakeCase()}}}}
/// {{package_name.pascalCase()}} description
/// {@endtemplate}
class {{package_name.pascalCase()}} implements I{{package_name.pascalCase()}} {
  /// {@macro {{{package_name.snakeCase()}}}}
  {{package_name.pascalCase()}}({
    required Cache<User> cache,
    {{package_name.pascalCase()}}Client? client,
  })  : _cache = cache,
        _client = client ?? {{package_name.pascalCase()}}Client(Dio());

  final Cache<User> _cache;
  final {{package_name.pascalCase()}}Client _client;
{{#methods}}
  @override
  TaskEither<String, {{{type}}}> {{name}}() {
    //TODO: Add Logic
    return TaskEither<String, User>.tryCatch(
      () async {
        final response = await _client.getUser();
        await _cache.put(I{{package_name.pascalCase()}}.cacheKey, response);

        return response;
      },
      (error, stackTrace) => 'error',
    );
  }
{{/methods}}
  @override
  Future<User?> get userData {
    return _cache.get(I{{package_name.pascalCase()}}.cacheKey);
  }

  @override
  Stream<User?> get userDataStream async* {
    final initial = await userData;

    yield* _cache
        .on<CacheEntryUpdatedEvent<User>>()
        .map((event) => event.newEntry.value as User?)
        .shareValueSeeded(initial);
  }
}
