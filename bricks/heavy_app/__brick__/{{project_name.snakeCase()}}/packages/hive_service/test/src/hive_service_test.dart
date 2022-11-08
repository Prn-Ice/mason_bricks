// ignore_for_file: prefer_const_constructors
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_service/hive_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider/path_provider.dart';

class MockHiveInterface extends Mock implements HiveInterface {}

class MockBox extends Mock implements Box<dynamic> {}

void main() {
  group('HiveService', () {
    late HiveInterface hive;
    late HiveService service;
    late Box<dynamic> box;
    const name = 'name';

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();

      MethodChannel('plugins.flutter.io/path_provider_macos')
          .setMockMethodCallHandler((MethodCall methodCall) async => '.');

      hive = MockHiveInterface();
      service = HiveService(name: name, hive: hive);
      box = MockBox();

      when(() => hive.box<dynamic>(name)).thenReturn(box);
      when(() => hive.openBox<dynamic>(name)).thenAnswer(
        (_) => Future.value(box),
      );
    });

    test('can be instantiated', () {
      expect(HiveService(name: 'name'), isNotNull);
    });

    group('box', () {
      test(
        'when hive.box completes successfully '
        'returns a box created from the given path',
        () async {
          final value = await service.box;

          verify(() => hive.box<dynamic>(name)).called(1);
          expect(value, equals(box));
        },
      );

      test(
        'when hive.box fails, call initializeHive and '
        'returns a box created from the given path',
        () async {
          /// This fix gotten from [https://stackoverflow.com/questions/69687714/mock-different-answers-and-exceptions-after-several-calls-with-mocktail?noredirect=1&lq=1](here)
          final answers = <Box<dynamic> Function(Invocation)>[
            (_) => throw Exception(),
            (_) => box,
          ];

          when(() => hive.box<dynamic>(name)).thenAnswer(
            (_) => answers.removeAt(0)(_),
          );

          expect(await service.box, equals(box));
          final directory = await getApplicationDocumentsDirectory();

          verify(() => hive.box<dynamic>(name)).called(2);
          verify(() => hive.openBox<dynamic>(name)).called(1);
          verify(() => hive.init(directory.path)).called(1);
          verifyNoMoreInteractions(hive);
        },
      );
    });

    group('initializeHive', () {
      test(
        'calls hive.init and hive.openBox with the given name',
        () async {
          await service.initializeHive();
          final directory = await getApplicationDocumentsDirectory();

          verify(() => hive.init(directory.path)).called(1);
          verify(() => hive.openBox<dynamic>(name)).called(1);
          verifyNoMoreInteractions(hive);
        },
      );

      test(
        'when hive.init fails make no further calls',
        () async {
          final directory = await getApplicationDocumentsDirectory();
          when(() => hive.init(directory.path)).thenThrow(Exception);

          await service.initializeHive();

          verify(() => hive.init(directory.path)).called(1);
          verifyNoMoreInteractions(hive);
        },
      );

      test(
        'when hive.openBox fails make no further calls',
        () async {
          when(() => hive.openBox<dynamic>(name)).thenThrow(Exception);

          await service.initializeHive();
          final directory = await getApplicationDocumentsDirectory();

          verify(() => hive.init(directory.path)).called(1);
          verify(() => hive.openBox<dynamic>(name)).called(1);
          verifyNoMoreInteractions(hive);
        },
      );
    });
  });
}
