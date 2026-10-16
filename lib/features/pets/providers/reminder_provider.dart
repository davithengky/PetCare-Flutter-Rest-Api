import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/notification_service.dart';
import '../../../data/api/api_client.dart';
import '../../../data/models/reminder_model.dart';
import '../../../data/repositories/api_reminder_repo.dart';
import '../../../data/repositories/reminder_repo.dart';

/// Provider singleton untuk repository pengingat.
final reminderRepoProvider = Provider<ReminderRepo>((ref) {
  return ApiReminderRepo(ref.watch(apiClientProvider));
});

/// Provider instance NotificationService.
final notificationServiceProvider = Provider<NotificationService>((ref) {
  final service = NotificationService();
  service.init();
  return service;
});

/// Provider family daftar pengingat hewan per petId.
final petRemindersProvider =
    FutureProvider.family<List<Reminder>, int>((ref, petId) {
  return ref.watch(reminderRepoProvider).getRemindersByPet(petId);
});

/// Notifier untuk menambah pengingat sekaligus menjadwalkan notifikasi lokal.
class AddReminderNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> addReminder(Reminder reminder) async {
    state = const AsyncLoading();
    try {
      final created =
          await ref.read(reminderRepoProvider).createReminder(reminder);

      // Jadwalkan notifikasi lokal jika memiliki notificationId dan aktif
      if (created.isActive && created.notificationId != null) {
        final notifService = ref.read(notificationServiceProvider);
        await notifService.scheduleReminder(
          id: created.notificationId!,
          title: 'Pengingat PetCare: ${created.title}',
          body:
              'Waktunya jadwal ${created.type} untuk anabul Anda! Buka aplikasi PetCare.',
          scheduledTime: created.scheduledTime,
        );
      }

      ref.invalidate(petRemindersProvider(reminder.petId));
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final addReminderProvider =
    AsyncNotifierProvider<AddReminderNotifier, void>(
  AddReminderNotifier.new,
);

/// Notifier untuk menghapus pengingat sekaligus membatalkan notifikasi lokal.
class DeleteReminderNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<bool> deleteReminder(Reminder reminder) async {
    state = const AsyncLoading();
    try {
      await ref.read(reminderRepoProvider).deleteReminder(reminder.id);

      if (reminder.notificationId != null) {
        final notifService = ref.read(notificationServiceProvider);
        await notifService.cancel(reminder.notificationId!);
      }

      ref.invalidate(petRemindersProvider(reminder.petId));
      state = const AsyncData(null);
      return true;
    } catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

final deleteReminderProvider =
    AsyncNotifierProvider<DeleteReminderNotifier, void>(
  DeleteReminderNotifier.new,
);
