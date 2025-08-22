import 'package:intl/intl.dart';

class DateValidators {
  static bool isInCurrentMonth(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month;
  }

  static String yMd(DateTime d) => DateFormat('yyyy-MM-dd').format(d);

  static DateTime parseYMd(String s) => DateFormat('yyyy-MM-dd').parse(s);
}
