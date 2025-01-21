// coverage:ignore-file
import 'package:intl/intl.dart';

extension CustomDateFormat on DateTime {
  String get format {
    final day = DateFormat('EEEE').format(this);
    final date = DateFormat('d').format(this);
    final month = DateFormat('MMMM').format(this);
    final year = DateFormat('yyyy').format(this);

    final ordinalDate = _getDayOfMonthSuffix(int.parse(date));

    return '$day, $date$ordinalDate $month $year';
  }

  String _getDayOfMonthSuffix(int n) {
    assert(n >= 1 && n <= 31, 'illegal day of month: $n');
    if (n >= 11 && n <= 13) {
      return 'th';
    }
    switch (n % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
