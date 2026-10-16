/// Model data untuk pesan obrolan dalam sesi chat bot PetCare.
class Message {
  final int id;
  final int consultationId;
  final int senderId; // 0 untuk PetBot, user.id untuk pengguna
  final String senderType; // 'user' | 'bot'
  final String text;
  final DateTime createdAt;

  const Message({
    required this.id,
    required this.consultationId,
    required this.senderId,
    required this.senderType,
    required this.text,
    required this.createdAt,
  });

  /// Membuat instance [Message] dari JSON map.
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as int,
      consultationId: json['consultation_id'] as int,
      senderId: json['sender_id'] as int,
      senderType: json['sender_type'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Mengonversi instance [Message] ke JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'consultation_id': consultationId,
      'sender_id': senderId,
      'sender_type': senderType,
      'text': text,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Membuat salinan objek dengan nilai baru yang opsional.
  Message copyWith({
    int? id,
    int? consultationId,
    int? senderId,
    String? senderType,
    String? text,
    DateTime? createdAt,
  }) {
    return Message(
      id: id ?? this.id,
      consultationId: consultationId ?? this.consultationId,
      senderId: senderId ?? this.senderId,
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Message(id: $id, consultationId: $consultationId, senderId: $senderId, senderType: $senderType, text: $text, createdAt: ${createdAt.toIso8601String()})';
  }
}
