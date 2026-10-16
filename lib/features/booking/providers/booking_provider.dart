import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/api/api_client.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/repositories/api_booking_repo.dart';
import '../../../data/repositories/booking_repo.dart';
import '../../auth/providers/auth_provider.dart';

/// Provider singleton repositori booking.
final bookingRepoProvider = Provider<BookingRepo>((ref) {
  return ApiBookingRepo(ref.watch(apiClientProvider));
});

/// FutureProvider daftar riwayat booking milik user yang sedang aktif.
final userBookingsProvider = FutureProvider<List<Booking>>((ref) async {
  final user = ref.watch(authProvider).value?.user;
  if (user == null) return [];
  final repo = ref.watch(bookingRepoProvider);
  return repo.getUserBookings(user.id);
});

/// AsyncNotifier untuk aksi membuat booking baru.
class CreateBookingNotifier extends AsyncNotifier<Booking?> {
  @override
  Future<Booking?> build() async => null;

  Future<Booking?> submitBooking({
    required int clinicId,
    required int petId,
    required String bookingType,
    required DateTime scheduleDate,
    String? notes,
  }) async {
    final user = ref.read(authProvider).value?.user;
    if (user == null) {
      state = AsyncError(Exception('Pengguna belum login'), StackTrace.current);
      return null;
    }

    state = const AsyncLoading();
    try {
      final repo = ref.read(bookingRepoProvider);
      final booking = await repo.createBooking(
        userId: user.id,
        clinicId: clinicId,
        petId: petId,
        bookingType: bookingType,
        scheduleDate: scheduleDate,
        notes: notes,
      );

      // Refresh riwayat booking
      ref.invalidate(userBookingsProvider);

      state = AsyncData(booking);
      return booking;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

/// Provider notifier untuk membuat booking baru.
final createBookingProvider =
    AsyncNotifierProvider<CreateBookingNotifier, Booking?>(
  CreateBookingNotifier.new,
);
