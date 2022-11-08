import 'package:hive/hive.dart';
import 'package:hive_repository/hive_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHiveBox extends Mock implements Box<dynamic> {}

class AccountRepository extends HiveRepository<String> {
  AccountRepository(Box<dynamic> box) : super(box: box);

  @override
  String fromJson(Map<String, dynamic> json) => json['account'] as String;

  @override
  Map<String, dynamic>? toJson(String item) =>
      <String, dynamic>{'account': item};
}

void main() {
  group('HiveRepositoryTest', () {
    late Box<dynamic> box;

    setUp(() {
      box = MockHiveBox();
      when<dynamic>(() => box.get(any<dynamic>())).thenReturn(0);
      when(() => box.put(any<dynamic>(), any<dynamic>()))
          // ignore: no-empty-block
          .thenAnswer((_) async {});
      when(() => box.clear()).thenAnswer((_) async => 0);
    });

    tearDown(() {
      box.clear();
    });

    group('get', () {
      test('returns null when box is not open', () {
        when(() => box.isOpen).thenReturn(false);
        expect(AccountRepository(box).get('key'), isNull);
      });

      test('returns correct value when box is open', () {
        when(() => box.isOpen).thenReturn(true);
        when<dynamic>(() => box.get(any<dynamic>()))
            .thenReturn({'account': 'Account()'});
        expect(AccountRepository(box).get('key'), 'Account()');
        verify<dynamic>(() => box.get('key')).called(1);
      });
    });
  });
}
