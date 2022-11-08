import 'package:dio_service/dio_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:{{package_name.snakeCase()}}/{{package_name.snakeCase()}}.dart';
import 'package:{{package_name.snakeCase()}}/src/client/{{package_name.snakeCase()}}_client.dart';
import 'package:rxdart/rxdart.dart';

import 'local_data_source/local_data_source.dart';

part 'i_{{package_name.snakeCase()}}.dart';

/// {@template {{{package_name.snakeCase()}}}}
/// {{package_name.pascalCase()}} description
/// {@endtemplate}
class {{package_name.pascalCase()}} implements I{{package_name.pascalCase()}} {
  /// {@macro {{{package_name.snakeCase()}}}}
  {{package_name.pascalCase()}}({
    required Box<dynamic> box,
    required DioService dioService,
    {{package_name.pascalCase()}}Client? client,
    LocalDataSource? localDataSource,
  })  : _client = client ?? {{package_name.pascalCase()}}Client(Dio()), 
        _localDataSource = localDataSource ?? LocalDataSource(box: box);

  final {{package_name.pascalCase()}}Client _client;
  final LocalDataSource _localDataSource;
{{#methods}}
  @override
  TaskEither<String, {{{type}}}> {{name}}() {
    //TODO: Add Logic
    return TaskEither<String, User>.tryCatch(
      () async {
        final response = await _client.getUser();
        await _localDataSource.put(LocalDataSource.key, response);

        return response;
      },
      (error, stackTrace) => 'error',
    );
  }
{{/methods}}
  @override
  Future<User?> get userData {
    return _localDataSource.user;
  }

  @override
  DeferStream<User?> get userDataStream {
    return _localDataSource.userStream;
  }
}
