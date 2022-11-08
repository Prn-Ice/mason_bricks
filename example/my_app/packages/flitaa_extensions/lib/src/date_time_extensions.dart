import 'package:intl/intl.dart';

extension DateTimeExtensions on DateTime? {
  String get toDateTime {
    return DateFormat('MMMM d, hh:mm aaa').format(this ?? DateTime(0));
  }

  String get toSlashedDateTime {
    return DateFormat('dd/MM/yyyy').format(this ?? DateTime(0));
  }

  String get toMonthDay {
    return DateFormat('MMMM d').format(this ?? DateTime(0));
  }

  String get toMonth {
    return DateFormat('MMMM').format(this ?? DateTime(0));
  }

  String get toDay {
    return DateFormat(DateFormat.MONTH_DAY).format(this ?? DateTime(0));
  }

  String get toYear {
    return DateFormat(DateFormat.YEAR_MONTH_DAY).format(this ?? DateTime(0));
  }
}

extension StringDateTimeExtensions on String? {
  String get toSlashedDateTime {
    return DateFormat('dd/MM/yyyy')
        .format(DateTime.parse(this ?? '01/01/1970'));
  }

  /// Parses this string to a `DateTime` object.
  ///
  /// Tries to parse `'01/01/1970'` if this is null.
  ///
  /// Returns `DateTime(0)` if parsing fails.
  DateTime get toDateTime {
    return DateTime.tryParse(this ?? '01/01/1970') ?? DateTime(0);
  }
}
