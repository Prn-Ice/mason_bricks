import 'package:mocktail/mocktail.dart';
import 'package:my_repository/my_repository.dart';
import 'package:stash/stash_api.dart';
import 'package:test/test.dart';

class MockCache extends Mock implements Cache<User> {}

void main() {
  group('MyRepository', () {
    late MyRepository myRepository;

    setUp(() {
      myRepository = MyRepository(cache: MockCache());
    });

    test('can be instantiated', () {
      expect(MyRepository(cache: MockCache()), isNotNull);
    });
    
    group('meUser', () {
      test('executes happy flow', () async {
        final someValue = myRepository.meUser();
        //expect(someValue, equals(someValue));
      });

      test('executes edge flow', () async {
        final someValue = myRepository.meUser();
        //expect(someValue, equals(someValue));
      });
    });
    
  });
}
