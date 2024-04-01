import 'package:intl/intl.dart';

// format số tiền
class TextFormat {
  final formatter = NumberFormat("#,###");

  static String formatMoney(double number) {
    return NumberFormat("#,###").format(number);
  }

  static String formatMoneyWithSymbol(double number) {
    return '${NumberFormat("#,###", "vi_VN").format(number)}đ';
  }

  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date);
  }
}
