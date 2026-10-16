// Model untuk pengingat (Reminder) vaksin/obat/grooming

/// Representasi pengingat perawatan hewan.
class Reminder {
  final int id;
  final int petId;
  final String title;
  final String type; // 'vaccine' | 'medicine' | 'grooming'
  final DateTime scheduledTime;
  final bool isActive;
  final int? notificationId;

  const Reminder({
    required this.id,
    required this.petId,
    required this.title,
    required this.type,
    required this.scheduledTime,
    required this.isActive,
    this.notificationId,
  });

  /// Factory constructor dari Map/JSON.
  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'] as int,
      petId: json['pet_id'] as int,
      title: json['title'] as String,
      type: json['type'] as String,
      scheduledTime: DateTime.parse(json['scheduled_time'] as String),
      isActive: json['is_active'] as bool? ?? true,
      notificationId: json['notification_id'] as int?,
    );
  }

  /// Mengonversi Reminder ke bentuk Map/JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_id': petId,
      'title': title,
      'type': type,
      'scheduled_time': scheduledTime.toIso8601String(),
      'is_active': isActive,
      'notification_id': notificationId,
    };
  }

  /// Membuat salinan Reminder dengan nilai baru.
  Reminder copyWith({
    int? id,
    int? petId,
    String? title,
    String? type,
    DateTime? scheduledTime,
    bool? isActive,
    int? notificationId,
  }) {
    return Reminder(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      title: title ?? this.title,
      type: type ?? this.type,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isActive: isActive ?? this.isActive,
      notificationId: notificationId ?? this.notificationId,
    );
  }

  @override
  String toString() {
    return 'Reminder(id: $id, petId: $petId, title: $title, type: $type, scheduledTime: $scheduledTime, isActive: $isActive, notificationId: $notificationId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Reminder &&
        other.id == id &&
        other.petId == petId &&
        other.title == title &&
        other.type == type &&
        other.scheduledTime == scheduledTime &&
        other.isActive == isActive &&
        other.notificationId == notificationId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      petId,
      title,
      type,
      scheduledTime,
      isActive,
      notificationId,
    );
  }
}
