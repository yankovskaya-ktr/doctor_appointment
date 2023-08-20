import 'package:intl/intl.dart';

class Format {
  static String time(DateTime date) {
    return DateFormat('HH:mm').format(date);
  }

  static String date(DateTime date) {
    return DateFormat('dd.MM').format(date);
  }

  static String dateAndDayOfWeek(DateTime date) {
    return DateFormat('dd.MM EEE').format(date);
  }

  static String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }
}
