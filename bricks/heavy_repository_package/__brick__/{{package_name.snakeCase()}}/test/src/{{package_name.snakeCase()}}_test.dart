import 'package:dio_service/dio_service.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:{{package_name.snakeCase()}}/{{package_name.snakeCase()}}.dart';
import 'package:test/test.dart';

class MockBox extends Mock implements Box<dynamic> {}

class MockDioService extends Mock implements DioService {}

void main() {
  group('{{package_name.pascalCase()}}', () {
    late {{package_name.pascalCase()}} {{package_name.camelCase()}};

    setUp(() {
      {{package_name.camelCase()}} = {{package_name.pascalCase()}}(box: MockBox(), dioService: MockDioService());
    });

    test('can be instantiated', () {
      expect(
        {{package_name.pascalCase()}}(box: MockBox(), dioService: MockDioService()), 
        isNotNull,
      );
    });
    {{#methods}}
    group('{{name}}', () {
      test('executes happy flow', () async {
        final someValue = {{package_name.camelCase()}}.{{name}}();
        expect(someValue, equals(someValue));
      });

      test('executes edge flow', () async {
        final someValue = {{package_name.camelCase()}}.{{name}}();
        expect(someValue, equals(someValue));
      });
    });
    {{/methods}}
  });
}
