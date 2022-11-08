import 'package:intl/intl.dart';

import 'flitaa_double_extensions.dart';

extension DynamicExtensions on dynamic {
  double get getDouble {
    return this is num
        ? (this as num).toDouble()
        : (double.tryParse(toString().trim().replaceAll(',', '')) ?? 0);
  }

  /// String value of a double truncated to `decimalLength` places.
  ///
  /// If `convertToDouble` is true, the truncated string is first converted to a
  /// double and then to a string.
  /// Eg.
  /// ```dart
  /// getTruncatedDouble(0.0000000083, decimalLength: 6);   //0.000000
  /// getTruncatedDouble(0.0000000083, decimalLength: 6, convertToDouble: true);   //0.0
  /// ```
  String toTruncatedDouble({
    int? decimalLength,
    bool convertToDouble = true,
  }) {
    final doubleVal = getDouble;

    if (doubleVal == 0) {
      return '0';
    } else {
      var stringVal = doubleVal.toStringAsFixed(10);

      if (stringVal.split('.').length <= 1) {
        return '0';
      }

      final numberSection = stringVal.split('.').first;

      /// Want to make it so that once [numberSection] crosses a million
      /// [decimalSection] reduces by one as [numberSection] increases
      ///
      /// A million = 1000000, thats seven
      /// So while [numberSection] is <= 8 continue as normal
      /// (8 cause we already decided max length of [decimalSection] == 8)
      /// Else if [numberSection] > 8
      /// calculate the difference eg if [numberSection] = 9, diff = 9 - 8 = 1
      /// then subtract diff from 8

      var decimalMaxLength = decimalLength ?? 6;
      final numberSectionLength = numberSection.length;

      if (numberSectionLength > 8) {
        final lengthDiff = numberSectionLength - decimalMaxLength;

        decimalMaxLength =
            lengthDiff >= decimalMaxLength ? 1 : decimalMaxLength - lengthDiff;
      }

      final decimalSection =
          stringVal.split('.')[1].substring(0, decimalMaxLength);

      stringVal = '$numberSection.$decimalSection';
      if (convertToDouble) {
        stringVal = stringVal.getDouble.toString();
      }

      return stringVal;
    }
  }

  /// Return a double formatted to display as a currency
  /// ie (comma separated).
  String get toSafeNumCurrency {
    final localeFormat = NumberFormat.currency(
      locale: Intl.defaultLocale,
      symbol: '',
    );
    final doubleVal = getDouble;

    return localeFormat.format(doubleVal);
  }

  /// Returns `safeNumCurrency` if `lengthOfIntegerPart` > 3
  /// else returns `getTruncatedDouble` with `decimalLength = 4`.
  String get toFormattedSafeNumCurrency {
    final doubleVal = getDouble;

    return doubleVal.lengthOfIntegerPart > 3
        ? doubleVal.toSafeNumCurrency
        : doubleVal.toTruncatedDouble(decimalLength: 6);
  }
}
