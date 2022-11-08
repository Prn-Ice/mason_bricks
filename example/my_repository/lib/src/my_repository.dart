import 'package:dio_service/dio_service.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive/hive.dart';
import 'package:my_repository/my_repository.dart';
import 'package:my_repository/src/client/my_repository_client.dart';
import 'package:rxdart/rxdart.dart';

import 'local_data_source/local_data_source.dart';

part 'i_my_repository.dart';

/// {@template my_repository}
/// MyRepository description
/// {@endtemplate}
class MyRepository implements IMyRepository {
  /// {@macro my_repository}
  MyRepository({
    required Box<dynamic> box,
    required DioService dioService,
    MyRepositoryClient? client,
    LocalDataSource? localDataSource,
  })  : _client = client ?? MyRepositoryClient(dioService.dio), 
        _localDataSource = localDataSource ?? LocalDataSource(box: box);

  final MyRepositoryClient _client;
  final LocalDataSource _localDataSource;

  @override
  TaskEither<String, User> getUser() {
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

  @override
  User? get userData {
    return _localDataSource.user;
  }

  @override
  DeferStream<User?> get userDataStream {
    return _localDataSource.userStream;
  }
}
