import '../models/booking_model.dart';

/// Kontrak repositori untuk data booking layanan klinik hewan.
abstract class BookingRepo {
  /// Mengambil daftar booking untuk [userId].
  Future<List<Booking>> getUserBookings(int userId);

  /// Mengambil detail booking berdasarkan [id].
  Future<Booking?> getBookingById(int id);

  /// Membuat pesanan booking baru.
  Future<Booking> createBooking({
    required int userId,
    required int clinicId,
    required int petId,
    required String bookingType,
    required DateTime scheduleDate,
    String? notes,
  });
}
