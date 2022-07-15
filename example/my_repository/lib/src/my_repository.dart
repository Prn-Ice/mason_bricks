import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:my_repository/my_repository.dart';
import 'package:my_repository/src/client/my_repository_client.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stash/stash_api.dart';

part 'i_my_repository.dart';

/// {@template my_repository}
/// MyRepository description
/// {@endtemplate}
class MyRepository implements IMyRepository { 
  /// {@macro my_repository}
  MyRepository({
    required Cache<User> cache,
    MyRepositoryClient? client,
  })  : _cache = cache,
        _client = client ?? MyRepositoryClient(Dio());

  final Cache<User> _cache;
  final MyRepositoryClient _client;

  @override
  TaskEither<String, User> myUser() {
    //TODO: Add Logic
    return TaskEither<String, User>.tryCatch(
      () async {
        final response = await _client.getUser();
        await _cache.put(IMyRepository.cacheKey, response);

        return response;
      },
      (error, stackTrace) => 'error',
    );
  }

  @override
  Future<User?> get userData {
    return _cache.get(IMyRepository.cacheKey);
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
