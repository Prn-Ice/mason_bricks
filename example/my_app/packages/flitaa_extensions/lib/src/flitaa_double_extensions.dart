import 'dynamic_extensions.dart';

extension FlitaaDoubleExtensions on double {
  /// Length of just integers in a double,
  /// eg 1234.5 has a length 4
  int get lengthOfIntegerPart {
    final doubleVal = getDouble;
    if (doubleVal == 0) {
      return 0;
    } else {
      final stringVal = doubleVal.toStringAsFixed(10);
      final numberSection = stringVal.split('.').first;

      return numberSection.length;
    }
  }
}
