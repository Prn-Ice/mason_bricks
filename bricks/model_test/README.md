# Model test

A brick that generates a test file for a standard model class that supports `copyWith`, `fromJson` and `toJson`.



## How to use 🚀

```sh
mason make model_test --name AccountModel
```



## Variables ✨

| Variable | Description           | Default | Type     |
| -------- | --------------------- | ------- | -------- |
| `name`   | The name of the model | User    | `string` |



## Outputs 📦

```sh
.
└── account_model_test.dart
```

```dart
import 'package:test/test.dart';

void main() {
  group('AccountModel', () {
    AccountModel createSubject() {
      return AccountModel();
    }

    group('constructor', () {
      test('works correctly', () {
        expect(createSubject, returnsNormally);
      });
    });

    test('supports value equality', () {
      expect(createSubject(), createSubject());
    });

    group('copyWith', () {
      test('returns the same object if not arguments are provided', () {
        expect(
          createSubject().copyWith(),
          equals(createSubject()),
        );
      });

      test('replaces every parameter, even when null', () {
        expect(
          createSubject().copyWith(),
          equals(
            createSubject(),
          ),
        );
      });
    });

    group('fromJson', () {
      test('works correctly', () {
        expect(
          AccountModel.fromJson(<String, dynamic>{}),
          equals(createSubject()),
        );
      });
    });

    group('toJson', () {
      test('works correctly', () {
        expect(
          createSubject().toJson(),
          equals(<String, dynamic>{}),
        );
      });
    });
  });
}

```

