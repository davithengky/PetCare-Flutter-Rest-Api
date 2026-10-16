import '../models/reminder_model.dart';

/// Kontrak repository untuk pengingat perawatan hewan.
abstract class ReminderRepo {
  /// Mendapatkan daftar pengingat berdasarkan ID hewan.
  Future<List<Reminder>> getRemindersByPet(int petId);

  /// Menambahkan jadwal pengingat baru.
  Future<Reminder> createReminder(Reminder reminder);

  /// Memperbarui jadwal pengingat.
  Future<Reminder> updateReminder(Reminder reminder);

  /// Menghapus jadwal pengingat berdasarkan ID.
  Future<void> deleteReminder(int id);
}
