import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

/// Layanan notifikasi lokal untuk pengingat jadwal perawatan, obat, dan vaksin hewan.
class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  /// Inisialisasi plugin dan konfigurasi zona waktu.
  Future<void> init() async {
    if (_isInitialized) return;

    // Inisialisasi timezone database
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        // Handler saat notifikasi di-tap oleh pengguna
      },
    );

    // Minta izin notifikasi (Android 13+)
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      await androidImpl.requestNotificationsPermission();
    }

    _isInitialized = true;
  }

  /// Menjadwalkan pengingat notifikasi pada waktu tertentu.
  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    if (!_isInitialized) {
      await init();
    }

    final now = DateTime.now();
    DateTime targetTime = scheduledTime;
    // Jika waktu sudah lewat, jadwalkan 5 detik ke depan untuk pengujian
    if (targetTime.isBefore(now)) {
      targetTime = now.add(const Duration(seconds: 5));
    }

    final scheduledDate = tz.TZDateTime.from(targetTime, tz.local);

    const androidDetails = AndroidNotificationDetails(
      'petcare_reminders',
      'Pengingat PetCare',
      channelDescription:
          'Notifikasi jadwal vaksin, obat, dan grooming anabul kesayangan Anda',
      importance: Importance.high,
      priority: Priority.high,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
    );

    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: scheduledDate,
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  /// Membatalkan pengingat berdasarkan ID notifikasi.
  Future<void> cancel(int id) async {
    await _plugin.cancel(id: id);
  }

  /// Membatalkan seluruh pengingat yang aktif.
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
