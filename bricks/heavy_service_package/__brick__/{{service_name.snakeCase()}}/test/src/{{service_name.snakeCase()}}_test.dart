import 'package:{{service_name.snakeCase()}}/{{service_name.snakeCase()}}.dart';
import 'package:test/test.dart';

void main() {
  group('{{service_name.pascalCase()}}', () {
    late {{service_name.pascalCase()}} {{service_name.camelCase()}};

    setUp(() {
      {{service_name.camelCase()}} = const {{service_name.pascalCase()}}();
    });

    test('can be instantiated', () {
      expect(const {{service_name.pascalCase()}}(), isNotNull);
    });
    {{#methods}}
    group('{{name}}', () {
      test('executes happy flow', () async {
        final someValue = {{service_name.camelCase()}}.{{name}}();
        //expect(someValue, equals(someValue));
      });

      test('executes edge flow', () async {
        final someValue = {{service_name.camelCase()}}.{{name}}();
        //expect(someValue, equals(someValue));
      });
    });
    {{/methods}}
  });
}
