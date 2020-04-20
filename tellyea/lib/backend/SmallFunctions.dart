import 'package:intl/intl.dart';

class SmallFunctions {
  static String formatDateTime(DateTime dateTime) => DateFormat('HH:mm').format(dateTime);
  static String formatFullDateTime(DateTime dateTime) => DateFormat('dd.MMM HH:mm').format(dateTime);
}
