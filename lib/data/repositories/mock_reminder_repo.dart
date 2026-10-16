import '../models/reminder_model.dart';
import 'reminder_repo.dart';

/// Implementasi Mock in-memory repository untuk pengingat.
class MockReminderRepo implements ReminderRepo {
  final List<Reminder> _reminders = [
    Reminder(
      id: 1,
      petId: 1,
      title: 'Booster Vaksin Tricat Tahunan',
      type: 'vaccine',
      scheduledTime: DateTime.now().add(const Duration(days: 5, hours: 2)),
      isActive: true,
      notificationId: 101,
    ),
    Reminder(
      id: 2,
      petId: 1,
      title: 'Minum Obat Cacing Berkala',
      type: 'medicine',
      scheduledTime: DateTime.now().add(const Duration(days: 12, hours: 4)),
      isActive: true,
      notificationId: 102,
    ),
    Reminder(
      id: 3,
      petId: 1,
      title: 'Sesi Grooming & Mandi Jamur',
      type: 'grooming',
      scheduledTime: DateTime.now().add(const Duration(days: 18)),
      isActive: true,
      notificationId: 103,
    ),
    Reminder(
      id: 4,
      petId: 2,
      title: 'Vaksin Rabies Rutin',
      type: 'vaccine',
      scheduledTime: DateTime.now().add(const Duration(days: 7)),
      isActive: true,
      notificationId: 104,
    ),
  ];

  int _nextId = 5;

  @override
  Future<List<Reminder>> getRemindersByPet(int petId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final list = _reminders
        .where((item) => item.petId == petId && item.isActive)
        .toList();
    list.sort((a, b) => a.scheduledTime.compareTo(b.scheduledTime));
    return list;
  }

  @override
  Future<Reminder> createReminder(Reminder reminder) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final newReminder = reminder.copyWith(
      id: _nextId++,
      notificationId: reminder.notificationId ?? _nextId + 1000,
    );
    _reminders.add(newReminder);
    return newReminder;
  }

  @override
  Future<Reminder> updateReminder(Reminder reminder) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _reminders.indexWhere((item) => item.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      return reminder;
    }
    return reminder;
  }

  @override
  Future<void> deleteReminder(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reminders.removeWhere((item) => item.id == id);
  }
}
