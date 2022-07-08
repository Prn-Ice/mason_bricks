import 'package:service_class/service_class.dart';
import 'package:test/test.dart';

void main() {
  group('ServiceClass', () {
    late ServiceClass serviceClass;

    setUp(() {
      serviceClass = const ServiceClass();
    });

    test('can be instantiated', () {
      expect(const ServiceClass(), isNotNull);
    });
    
  });
}
