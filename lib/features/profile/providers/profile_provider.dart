import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../consultation/providers/chat_provider.dart';
import '../../pets/providers/pets_provider.dart';
import '../../shop/providers/orders_provider.dart';

/// Notifier untuk menangani pembaruan data profil pengguna.
class EditProfileNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Memperbarui informasi profil pengguna (nama, telepon, alamat).
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    state = const AsyncLoading();
    try {
      final currentUser = ref.read(authProvider).value?.user;
      if (currentUser == null) return false;

      // Simpan perubahan ke server terlebih dahulu.
      final updatedUser = await ref.read(authRepoProvider).updateProfile(
            name: name,
            phone: phone,
            address: address,
          );

      // Perbarui user pada AuthNotifier (yang juga menyimpan sesi ke secure storage)
      ref.read(authProvider.notifier).updateUser(updatedUser);

      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

/// Provider untuk aksi edit profil pengguna.
final editProfileProvider =
    AsyncNotifierProvider<EditProfileNotifier, void>(EditProfileNotifier.new);

/// Model data statistik aktivitas pengguna di profil.
class ProfileStats {
  final int totalPets;
  final int totalBookings;
  final int totalOrders;
  final int totalConsultations;

  const ProfileStats({
    required this.totalPets,
    required this.totalBookings,
    required this.totalOrders,
    required this.totalConsultations,
  });
}

/// Provider untuk memuat data statistik pengguna (jumlah pet, booking, pesanan, konsultasi).
final profileStatsProvider = FutureProvider<ProfileStats>((ref) async {
  final userId = ref.watch(authProvider).value?.user?.id;
  if (userId == null) {
    return const ProfileStats(
      totalPets: 0,
      totalBookings: 0,
      totalOrders: 0,
      totalConsultations: 0,
    );
  }

  final pets = ref.watch(petsProvider).value ?? [];
  final bookings = await ref.watch(bookingRepoProvider).getUserBookings(userId);
  final orders = await ref.watch(orderRepoProvider).getUserOrders(userId);
  final consultations =
      await ref.watch(consultationRepoProvider).getUserConsultations(userId);

  return ProfileStats(
    totalPets: pets.length,
    totalBookings: bookings.length,
    totalOrders: orders.length,
    totalConsultations: consultations.length,
  );
});
