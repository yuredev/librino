import 'package:intl/intl.dart';

abstract class Converters {
  static String dateToBRLFormat(DateTime data) {
    return DateFormat('dd/MM/yyyy').format(data);
  }
}
