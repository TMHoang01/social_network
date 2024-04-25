import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// format số tiền
class TextFormat {
  final formatter = NumberFormat("#,###");

  static String formatMoney(num number) {
    return NumberFormat("#,###").format(number);
  }

  static String formatMoneyWithSymbol(double number) {
    return '${NumberFormat("#,###", "vi_VN").format(number)}đ';
  }

  static String formatDate(DateTime? date, {String formatType = 'dd/MM/yyyy'}) {
    if (date == null) return '';
    return DateFormat(formatType).format(date);
  }

  static DateTime parseDate(String date) {
    return DateFormat('dd/MM/yyyy').parse(date);
  }

  static DateTime? parseJson(dynamic json) {
    return json != null && json.toString().isNotEmpty
        ? (json is Timestamp ? (json).toDate() : DateTime.parse(json))
        : null;
  }
}
