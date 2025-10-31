import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _monthFormat = DateFormat('MMM yyyy');
  static final NumberFormat _currencyFormat = NumberFormat.currency(
    symbol: '\$',
    decimalDigits: 2,
  );

  static String formatDate(DateTime date) {
    return _dateFormat.format(date);
  }

  static String formatMonth(DateTime date) {
    return _monthFormat.format(date);
  }

  static String formatCurrency(double amount) {
    return _currencyFormat.format(amount);
  }

  static String formatPercentage(double percentage) {
    return '${(percentage * 100).toStringAsFixed(1)}%';
  }
}