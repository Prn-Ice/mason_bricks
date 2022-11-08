import 'package:hive/hive.dart';
import 'package:hive_repository/hive_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLazyHiveBox extends Mock implements LazyBox<dynamic> {}

class AccountRepository extends LazyHiveRepository<String> {
  AccountRepository(LazyBox<dynamic> box) : super(box: box);

  @override
  String fromJson(Map<String, dynamic> json) => json['account'] as String;

  @override
  Map<String, dynamic>? toJson(String item) =>
      <String, dynamic>{'account': item};
}

void main() {
  group('LocalHiveRepository', () {
    late LazyBox<dynamic> box;

    setUp(() {
      box = MockLazyHiveBox();
      when(() => box.get(any<dynamic>())).thenAnswer((_) async => 0);
      when(() => box.put(any<dynamic>(), any<dynamic>()))
          // ignore: no-empty-block
          .thenAnswer((_) async {});
      when(() => box.clear()).thenAnswer((_) async => 0);
    });

    tearDown(() {
      box.clear();
    });

    group('get', () {
      test('returns null when box is not open', () async {
        when(() => box.isOpen).thenReturn(false);
        final value = await AccountRepository(box).get('key');
        expect(value, isNull);
      });

      test('returns correct value when box is open', () async {
        when(() => box.isOpen).thenReturn(true);
        when(() => box.get(any<dynamic>()))
            .thenAnswer((_) async => {'account': 'Account()'});
        final value = await AccountRepository(box).get('key');
        expect(value, 'Account()');
        verify(() => box.get('key')).called(1);
      });
    });
  });
}
