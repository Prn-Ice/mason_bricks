# Heavy repository package

A brick that generates a repository package with an api client, data persistence and more..

## NOTE
The project has been updated but I don't have the time to update the doc right now so heres a brief of what you know.

- Use a [hive_repository](https://github.com/Prn-Ice/hive_repository) over the stash package
- Use a [dio_service](https://github.com/Prn-Ice/dio_service)
- Use [freezer](https://pub.dev/packages/freezer) instead of json_model

## How to use 🚀

```sh
mason make heavy_repository_package --package_name=MyRepository --package_description=Description --flutter=true --analysis=true
```



## Variables ✨

| Variable              | Description                                                  | Default                       | Type      |
| --------------------- | ------------------------------------------------------------ | ----------------------------- | --------- |
| `package_name`        | The name of the repository                                   | Repository                    | `string`  |
| `package_description` | This repositories's description                              | A default package description | `string`  |
| `flutter`             | Whether this service should depend on flutter                | false                         | `boolean` |
| `analysis`            | Whether this service should use the annoying_analysis_options brick | false                         | `boolean` |



## Bricks Used 🧱

| Brick                                                        | Version |
| ------------------------------------------------------------ | ------- |
| [annoying_analysis_options](https://brickhub.dev/bricks/annoying_analysis_options/0.0.3) | 0.0.3   |



## Outputs 📦

```sh
.
├── .json_models
│   └── response.jsonc
├── lib
│   ├── my_repository.dart
│   └── src
│       ├── client
│       │   ├── my_repository_client.dart
│       │   └── my_repository_client.g.dart
│       ├── models
│       │   ├── models.dart
│       │   └── user
│       │       ├── data.dart
│       │       ├── data.freezed.dart
│       │       ├── data.g.dart
│       │       ├── user.dart
│       │       ├── user.freezed.dart
│       │       └── user.g.dart
│       ├── i_my_repository.dart
│       └── my_repository.dart
├── README.md
├── analysis_options.yaml
├── pubspec.lock
├── pubspec.yaml
└── test
    └── src
        └── my_repository_test.dart
```



### Json Models

This template assumes you use [Json-to-Dart-Model](https://github.com/hiranthaR/Json-to-Dart-Model) to generate json models from reference files in the .json_models folder.

```json
[
    {
        "__className": "user",
        "__path": "/lib/src/models/user",
        "status": "success",
        "message": "",
        "data": {
            "firstName": "prince",
            "lastName": "nna"
        }
    }
]
```



### Client

This template also assumes that you use [Dio](https://pub.dev/packages/dio) as your HTTP adapter and [Retrofit](https://pub.dev/packages/retrofit) as your request generator. The client file is a retrofit class for all your network requests.

```dart
import 'package:dio/dio.dart';
import 'package:my_repository/my_repository.dart';
import 'package:retrofit/retrofit.dart';

part 'my_repository_client.g.dart';

@RestApi()
abstract class MyRepositoryClient {
  factory MyRepositoryClient(Dio dio, {String baseUrl}) = _MyRepositoryClient;

  @GET('/user/me')
  Future<User> getUser();
}
```



### Repository

This template assumes you prefer to use [functional programming](https://pub.dev/packages/fpdart) types and methods such as the `Either` type to handle errors, instead of the traditional `try-catch` system.

It also assumes that you use [stash](https://pub.dev/packages/stash) to cache responses from the `Client`.

```dart
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
  TaskEither<String, User> meUser() {
    //TODO: Add Logic
    return TaskEither<String, User>.tryCatch(
      () async {
        final response = await _client.getUser();
        // Store response in cache
        await _cache.put(IMyRepository.cacheKey, response);

        return response;
      },
      (error, stackTrace) => 'error',
    );
  }

  /// Cached data.
  @override
  Future<User?> get userData {
    return _cache.get(IMyRepository.cacheKey);
  }

  /// Cached data accessible as a stream
  /// with the value from [userData] injected as the initial data.
  @override
  Stream<User?> get userDataStream async* {
    final initial = await userData;

    yield* _cache
        .on<CacheEntryUpdatedEvent<User>>()
        .map((event) => event.newEntry.value as User?)
        .shareValueSeeded(initial);
  }
}
```



### Sample Usage in App

```dart
void main() {
  // Create a store,
  // you can create multiple caches from one store.
  final store = await newObjectboxLocalCacheStore();
  // Create a cache for users.
  final cache = await store.cache<User>(
      name: 'user',
      fromEncodable: User.fromJson,
  );

  // Create a repository with cache.
  final repository = MyRepository(cache: cache);
}
```

