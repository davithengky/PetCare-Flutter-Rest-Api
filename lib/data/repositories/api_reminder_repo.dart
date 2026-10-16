import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/reminder_model.dart';
import 'reminder_repo.dart';

/// Implementasi [ReminderRepo] yang terhubung ke REST API PetCare.
class ApiReminderRepo implements ReminderRepo {
  ApiReminderRepo(this._client);

  final ApiClient _client;

  @override
  Future<List<Reminder>> getRemindersByPet(int petId) async {
    final res = await _client.get('/pets/$petId/reminders');
    return apiList(res).map(Reminder.fromJson).toList();
  }

  @override
  Future<Reminder> createReminder(Reminder reminder) async {
    final res = await _client.post(
      '/pets/${reminder.petId}/reminders',
      body: _body(reminder),
    );
    return Reminder.fromJson(apiMap(res));
  }

  @override
  Future<Reminder> updateReminder(Reminder reminder) async {
    final res = await _client.put(
      '/reminders/${reminder.id}',
      body: _body(reminder),
    );
    return Reminder.fromJson(apiMap(res));
  }

  @override
  Future<void> deleteReminder(int id) async {
    await _client.delete('/reminders/$id');
  }

  /// Menyusun body permintaan sesuai aturan validasi backend.
  Map<String, dynamic> _body(Reminder reminder) {
    return {
      'title': reminder.title,
      'type': reminder.type,
      'scheduled_time': reminder.scheduledTime.toIso8601String(),
      'is_active': reminder.isActive,
      'notification_id': reminder.notificationId,
    };
  }
}
