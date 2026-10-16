import '../../core/errors/app_exception.dart';
import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/booking_model.dart';
import 'booking_repo.dart';

/// Implementasi [BookingRepo] yang terhubung ke REST API PetCare.
class ApiBookingRepo implements BookingRepo {
  ApiBookingRepo(this._client);

  final ApiClient _client;

  /// Cache pemetaan kode layanan -> id layanan dari endpoint `/services`.
  List<Map<String, dynamic>>? _services;

  @override
  Future<List<Booking>> getUserBookings(int userId) async {
    final res = await _client.get('/bookings');
    return apiList(res).map(Booking.fromJson).toList();
  }

  @override
  Future<Booking?> getBookingById(int id) async {
    final res = await _client.get('/bookings/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Booking.fromJson(map);
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
    final serviceId = await _resolveServiceId(bookingType);

    final res = await _client.post(
      '/bookings',
      body: {
        'clinic_id': clinicId,
        'pet_id': petId,
        'service_id': serviceId,
        'schedule_date': scheduleDate.toIso8601String(),
        'notes': notes,
      },
    );

    return Booking.fromJson(apiMap(res));
  }

  /// Menerjemahkan kode layanan aplikasi ('consultation', 'grooming', dst.)
  /// menjadi `service_id` yang diminta backend.
  Future<int> _resolveServiceId(String bookingType) async {
    _services ??= apiList(await _client.get('/services'));

    final normalized = bookingType.trim().toLowerCase();
    for (final service in _services!) {
      final code = (service['code'] as String?)?.toLowerCase();
      final name = (service['name'] as String?)?.toLowerCase();
      if (code == normalized || name == normalized) {
        return service['id'] as int;
      }
    }

    throw AppException(
      'Layanan "$bookingType" tidak tersedia di server.',
    );
  }
}
