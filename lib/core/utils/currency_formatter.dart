import 'package:intl/intl.dart';

/// Utilitas pemformatan mata uang Rupiah untuk aplikasi PetCare.
class CurrencyFormatter {
  // Private constructor
  CurrencyFormatter._();

  static final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );

  /// Memformat angka [amount] menjadi format mata uang Rupiah (contoh: "Rp 35.000").
  static String format(double amount) {
    return _formatter.format(amount);
  }
}
