# Heavy Service Package

A brick to create your service package including your methods, tests, and more! This package is highly inspired by(stolen from 😃) [Service Package](https://github.com/LukeMoody01/mason_bricks/tree/master/bricks/service_package).

This brick makes use of the MasonGenerator and wraps 1 other brick (annoying_analysis_options) to create a fully fledged package with tests already pre generated!

## How to use 🚀

```
mason make heavy_service_package --service_name "user service" --service_description "User service" --singleton_type=none --flutter=false --analysis=false
```

## Variables ✨

| Variable              | Description                                                  | Default                       | Type     |
| --------------------- | ------------------------------------------------------------ | ----------------------------- | -------- |
| `service_name`        | The name of the service                                      | service                       | `string` |
| `service_description` | The service's description                                    | A default package description | `string` |
| `singleton_type`      | The service's instance type                                  | none                          | enum     |
| `flutter`             | Whether this service should depend on flutter                | false                         | boolean  |
| `analysis`            | Whether this service should use the annoying_analysis_options brick | false                         | Boolean  |

## Bricks Used 🧱

| Brick                                                        | Version |
| ------------------------------------------------------------ | ------- |
| [annoying_analysis_options](https://brickhub.dev/bricks/annoying_analysis_options/0.0.1) | 0.0.1   |

## Outputs 📦

```
--service_name "user service" --service_description "User service"
├── user_service
│   ├── lib
│   │   ├── src
│   │   │   ├── user_service.dart
│   │   │   └── i_user_service.dart
│   │   └── user_service.dart
│   ├── test
│   │   └── src
│   │       └── user_service_test.dart
│   ├── .gitignore
│   ├── analysis_options.yaml
│   ├── pubspec.yaml
│   └── README.md
└── ...
```

### Service File

```dart
part 'i_user_service.dart';

/// {@template user_service}
/// UserService description
/// {@endtemplate}
class UserService implements IUserService {
  /// {@macro user_service}
  const UserService();

  @override
  FutureOr<String> authenticateUser() async {
    //TODO: Add Logic
    return Future.value();
  }

  @override
  FutureOr<String> logOut() async {
    //TODO: Add Logic
    return Future.value();
  }
}
```

### Tests File

```dart
import 'package:data_repository/data_repository.dart';
import 'package:test/test.dart';

void main() {
  group('UserService', () {
    late UserService userService;

    setUp(() {
      userService = const UserService();
    });

    test('can be instantiated', () {
      expect(const UserService(), isNotNull);
    });

    group('authenticateUser', () {
      test('executes happy flow', () async {
        final someValue = userService.authenticateUser();
        //expect(someValue, equals(someValue));
      });

      test('executes edge flow', () async {
        final someValue = userService.authenticateUser();
        //expect(someValue, equals(someValue));
      });
    });

    group('logOut', () {
      test('executes happy flow', () async {
        final someValue = userService.logOut();
        //expect(someValue, equals(someValue));
      });

      test('executes edge flow', () async {
        final someValue = userService.logOut();
        //expect(someValue, equals(someValue));
      });
    });
  });
}
```

