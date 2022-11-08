import 'package:hive/hive.dart';
import 'package:hive_repository/hive_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockHiveBoxBase extends Mock implements BoxBase<dynamic> {}

class AccountRepository extends BaseHiveRepository<String> {
  AccountRepository(BoxBase<dynamic> box) : super(box: box);

  @override
  String fromJson(Map<String, dynamic> json) => json['account'] as String;

  @override
  Map<String, dynamic>? toJson(String item) =>
      <String, dynamic>{'account': item};
}

void main() {
  group('BaseHiveRepository', () {
    late BoxBase<dynamic> box;

    setUp(() {
      box = MockHiveBoxBase();
      when(() => box.put(any<dynamic>(), any<dynamic>()))
          .thenAnswer((_) async {});
      when(() => box.delete(any<dynamic>())).thenAnswer((_) async {});
      when(() => box.clear()).thenAnswer((_) async => 0);
      when(() => box.close()).thenAnswer((_) async {});
      when(() => box.watch()).thenAnswer((_) async* {});
    });

    tearDown(() {
      box.clear();
    });

    group('put', () {
      test('does nothing when box is not open', () async {
        when(() => box.isOpen).thenReturn(false);
        await AccountRepository(box).put('key', 'Account()');
        verifyNever(() => box.put(any<dynamic>(), any<dynamic>()));
      });

      test('puts key/value in box when box is open', () async {
        when(() => box.isOpen).thenReturn(true);
        await AccountRepository(box).put('key', 'Account()');
        verify(() => box.put('key', <String, dynamic>{'account': 'Account()'}))
            .called(1);
      });
    });

    group('delete', () {
      test('does nothing when box is not open', () async {
        when(() => box.isOpen).thenReturn(false);
        await AccountRepository(box).delete('key');
        verifyNever(() => box.delete(any<dynamic>()));
      });

      test('puts key/value in box when box is open', () async {
        when(() => box.isOpen).thenReturn(true);
        await AccountRepository(box).delete('key');
        verify(() => box.delete('key')).called(1);
      });
    });

    group('clear', () {
      test('does nothing when box is not open', () async {
        when(() => box.isOpen).thenReturn(false);
        await AccountRepository(box).clear();
        verifyNever(() => box.clear());
      });

      test('clears box when box is open', () async {
        when(() => box.isOpen).thenReturn(true);
        await AccountRepository(box).clear();
        verify(() => box.clear()).called(1);
      });
    });

    group('count', () {
      test('returns 0 when box is not open', () async {
        when(() => box.isOpen).thenReturn(false);
        expect(AccountRepository(box).count, 0);
      });

      test('returns count of box when box is open', () async {
        when(() => box.isOpen).thenReturn(true);
        when(() => box.length).thenReturn(1);
        expect(AccountRepository(box).count, 1);
      });
    });

    group('close', () {
      test('does nothing when box is not open', () async {
        when(() => box.isOpen).thenReturn(false);
        AccountRepository(box).close();
        verifyNever(() => box.close());
      });

      test('closes box when box is open', () async {
        when(() => box.isOpen).thenReturn(true);
        AccountRepository(box).close();
        verify(() => box.close()).called(1);
      });
    });

    group('watch', () {
      test('does nothing when box is not open', () async {
        when(() => box.isOpen).thenReturn(false);
        AccountRepository(box).watch();
        verifyNever(() => box.watch());
      });

      test('watches box when box is open', () async {
        final repository = AccountRepository(box);
        when(() => box.isOpen).thenReturn(true);
        when<dynamic>(() => box.watch(key: any<dynamic>(named: 'key')))
            .thenAnswer(
          (_) => Stream.value(BoxEvent('key', {'account': 'Account()'}, false)),
        );

        await expectLater(
          repository.watch(),
          emitsInOrder(<String>['Account()']),
        );
        verify(() => box.watch()).called(1);
      });
    });
  });
}
