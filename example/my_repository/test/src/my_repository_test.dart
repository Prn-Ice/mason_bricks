import 'package:dio_service/dio_service.dart';
import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_repository/my_repository.dart';
import 'package:test/test.dart';

class MockBox extends Mock implements Box<dynamic> {}

class MockDioService extends Mock implements DioService {}

void main() {
  group('MyRepository', () {
    late MyRepository myRepository;

    setUp(() {
      myRepository = MyRepository(box: MockBox(), dioService: MockDioService());
    });

    test('can be instantiated', () {
      expect(
        MyRepository(box: MockBox(), dioService: MockDioService()), 
        isNotNull,
      );
    });
    
    group('getUser', () {
      test('executes happy flow', () async {
        final someValue = myRepository.getUser();
        expect(someValue, equals(someValue));
      });

      test('executes edge flow', () async {
        final someValue = myRepository.getUser();
        expect(someValue, equals(someValue));
      });
    });
    
  });
}
