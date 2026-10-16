import 'package:intl/intl.dart';

/// Utilitas pemformatan tanggal dan waktu untuk aplikasi PetCare.
class DateFormatter {
  // Private constructor
  DateFormatter._();

  static final DateFormat _fullDate = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  static final DateFormat _mediumDate = DateFormat('d MMMM yyyy', 'id_ID');
  static final DateFormat _shortDate = DateFormat('dd MMM yyyy', 'id_ID');
  static final DateFormat _time = DateFormat('HH:mm', 'id_ID');
  static final DateFormat _dateTime = DateFormat('d MMMM yyyy, HH:mm', 'id_ID');

  /// Contoh: "Senin, 12 Oktober 2026"
  static String fullDate(DateTime date) => _fullDate.format(date);

  /// Contoh: "12 Oktober 2026"
  static String mediumDate(DateTime date) => _mediumDate.format(date);

  /// Contoh: "12 Okt 2026"
  static String shortDate(DateTime date) => _shortDate.format(date);

  /// Contoh: "09:00"
  static String time(DateTime date) => _time.format(date);

  /// Contoh: "12 Oktober 2026, 09:00"
  static String dateTime(DateTime date) => _dateTime.format(date);
}
