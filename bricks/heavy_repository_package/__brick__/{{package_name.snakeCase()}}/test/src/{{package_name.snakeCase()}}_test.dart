import 'package:mocktail/mocktail.dart';
import 'package:{{package_name.snakeCase()}}/{{package_name.snakeCase()}}.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';

class MockCache extends Mock implements Cache<User> {}

void main() {
  group('{{package_name.pascalCase()}}', () {
    late {{package_name.pascalCase()}} {{package_name.camelCase()}};

    setUp(() {
      {{package_name.camelCase()}} = {{package_name.pascalCase()}}(cache: MockCache());
    });

    test('can be instantiated', () {
      expect({{package_name.pascalCase()}}(cache: MockCache()), isNotNull);
    });
    {{#methods}}
    group('{{name}}', () {
      test('executes happy flow', () async {
        final someValue = {{package_name.camelCase()}}.{{name}}();
        //expect(someValue, equals(someValue));
      });

      test('executes edge flow', () async {
        final someValue = {{package_name.camelCase()}}.{{name}}();
        //expect(someValue, equals(someValue));
      });
    });
    {{/methods}}
  });
}
