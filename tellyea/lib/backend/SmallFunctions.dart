import 'package:intl/intl.dart';

class SmallFunctions {
  static String formatDateTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);
  static String formatDateTimeMonthYear(DateTime dateTime) => DateFormat('MMM yyyy').format(dateTime);
  static String formatDateTimeDayMonthTime(DateTime dateTime) => DateFormat('dd.MMM HH:mm').format(dateTime);
}
