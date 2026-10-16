/// Model data untuk sesi percakapan antara pengguna dan PetBot.
class Consultation {
  final int id;
  final int userId;
  final String botName; // Nama bot, default 'PetBot'
  final int? petId; // Opsional — diisi jika user menyebut nama pet
  final String status; // 'active' | 'completed'
  final DateTime startedAt;
  final DateTime? endedAt;

  const Consultation({
    required this.id,
    required this.userId,
    this.botName = 'PetBot',
    this.petId,
    required this.status,
    required this.startedAt,
    this.endedAt,
  });

  /// Membuat instance [Consultation] dari JSON map.
  factory Consultation.fromJson(Map<String, dynamic> json) {
    return Consultation(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      botName: json['bot_name'] as String? ?? 'PetBot',
      petId: json['pet_id'] as int?,
      status: json['status'] as String,
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null
          ? DateTime.parse(json['ended_at'] as String)
          : null,
    );
  }

  /// Mengonversi instance [Consultation] ke JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'bot_name': botName,
      'pet_id': petId,
      'status': status,
      'started_at': startedAt.toIso8601String(),
      'ended_at': endedAt?.toIso8601String(),
    };
  }

  /// Membuat salinan objek dengan nilai baru yang opsional.
  Consultation copyWith({
    int? id,
    int? userId,
    String? botName,
    int? Function()? petId,
    String? status,
    DateTime? startedAt,
    DateTime? Function()? endedAt,
  }) {
    return Consultation(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      botName: botName ?? this.botName,
      petId: petId != null ? petId() : this.petId,
      status: status ?? this.status,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt != null ? endedAt() : this.endedAt,
    );
  }

  @override
  String toString() {
    return 'Consultation(id: $id, userId: $userId, botName: $botName, petId: $petId, status: $status, startedAt: ${startedAt.toIso8601String()}, endedAt: ${endedAt?.toIso8601String()})';
  }
}
