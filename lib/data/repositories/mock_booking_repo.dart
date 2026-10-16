import '../models/booking_model.dart';
import 'booking_repo.dart';

/// Implementasi in-memory mock repository untuk booking layanan klinik.
class MockBookingRepo implements BookingRepo {
  final List<Booking> _bookings = [
    // Dummy riwayat booking untuk demo (ditampilkan di semua akun).
    Booking(
      id: 1,
      userId: 1,
      clinicId: 1,
      petId: 1,
      bookingType: 'vaccination',
      scheduleDate: DateTime.now().add(const Duration(days: 1, hours: 2)),
      notes: 'Vaksin tahunan & cek kesehatan',
      status: 'confirmed',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    Booking(
      id: 2,
      userId: 1,
      clinicId: 2,
      petId: 1,
      bookingType: 'grooming',
      scheduleDate: DateTime.now().subtract(const Duration(days: 3)),
      notes: 'Grooming bulu dan potong kuku',
      status: 'completed',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
  ];
  int _nextId = 3;

  @override
  Future<List<Booking>> getUserBookings(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // Mode demo: seluruh riwayat mock ditampilkan untuk akun mana pun.
    final list = List<Booking>.from(_bookings);
    // Urutkan dari yang terbaru dibuat atau jadwal terdekat
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  @override
  Future<Booking?> getBookingById(int id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Booking> createBooking({
    required int userId,
    required int clinicId,
    required int petId,
    required String bookingType,
    required DateTime scheduleDate,
    String? notes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final newBooking = Booking(
      id: _nextId++,
      userId: userId,
      clinicId: clinicId,
      petId: petId,
      bookingType: bookingType,
      scheduleDate: scheduleDate,
      notes: notes,
      status: 'confirmed',
      createdAt: DateTime.now(),
    );

    _bookings.insert(0, newBooking);
    return newBooking;
  }
}
