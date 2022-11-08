import 'package:hive_repository/hive_repository.dart';
import 'package:test/test.dart';

void main() {
  group('HydratedCyclicError', () {
    test('toString override is correct', () {
      expect(
        HydratedCyclicError(<String, dynamic>{}).toString(),
        'Cyclic error while state traversing',
      );
    });
  });
}
