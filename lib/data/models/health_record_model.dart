// Model untuk rekam medis hewan peliharaan (HealthRecord)

/// Representasi rekam medis hewan peliharaan.
class HealthRecord {
  final int id;
  final int petId;
  final DateTime date;
  final String diagnosis;
  final String? medication;
  final String? notes;

  const HealthRecord({
    required this.id,
    required this.petId,
    required this.date,
    required this.diagnosis,
    this.medication,
    this.notes,
  });

  /// Factory constructor untuk membuat HealthRecord dari Map/JSON.
  factory HealthRecord.fromJson(Map<String, dynamic> json) {
    return HealthRecord(
      id: json['id'] as int,
      petId: json['pet_id'] as int,
      date: DateTime.parse(json['date'] as String),
      diagnosis: json['diagnosis'] as String,
      medication: json['medication'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Mengonversi HealthRecord ke bentuk Map/JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'pet_id': petId,
      'date': date.toIso8601String(),
      'diagnosis': diagnosis,
      'medication': medication,
      'notes': notes,
    };
  }

  /// Membuat salinan HealthRecord dengan field yang diperbarui.
  HealthRecord copyWith({
    int? id,
    int? petId,
    DateTime? date,
    String? diagnosis,
    String? medication,
    String? notes,
  }) {
    return HealthRecord(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      date: date ?? this.date,
      diagnosis: diagnosis ?? this.diagnosis,
      medication: medication ?? this.medication,
      notes: notes ?? this.notes,
    );
  }

  @override
  String toString() {
    return 'HealthRecord(id: $id, petId: $petId, date: $date, diagnosis: $diagnosis, medication: $medication, notes: $notes)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthRecord &&
        other.id == id &&
        other.petId == petId &&
        other.date == date &&
        other.diagnosis == diagnosis &&
        other.medication == medication &&
        other.notes == notes;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      petId,
      date,
      diagnosis,
      medication,
      notes,
    );
  }
}
