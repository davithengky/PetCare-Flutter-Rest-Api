/// Model data untuk jadwal booking layanan klinik hewan PetCare.
class Booking {
  final int id;
  final int userId;
  final int clinicId;
  final int petId;
  /// Jenis layanan yang dipilih: 'consultation' | 'grooming' | 'vaccination'
  final String bookingType;
  final DateTime scheduleDate;
  final String? notes;
  final String status; // 'pending' | 'confirmed' | 'completed' | 'cancelled'
  final DateTime createdAt;

  const Booking({
    required this.id,
    required this.userId,
    required this.clinicId,
    required this.petId,
    required this.bookingType,
    required this.scheduleDate,
    this.notes,
    this.status = 'confirmed',
    required this.createdAt,
  });

  /// Membuat instance [Booking] dari JSON map.
  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      clinicId: json['clinic_id'] as int,
      petId: json['pet_id'] as int,
      bookingType: json['booking_type'] as String,
      scheduleDate: DateTime.parse(json['schedule_date'] as String),
      notes: json['notes'] as String?,
      status: json['status'] as String? ?? 'confirmed',
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Mengonversi instance [Booking] ke JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'clinic_id': clinicId,
      'pet_id': petId,
      'booking_type': bookingType,
      'schedule_date': scheduleDate.toIso8601String(),
      'notes': notes,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Membuat salinan objek dengan nilai baru yang opsional.
  Booking copyWith({
    int? id,
    int? userId,
    int? clinicId,
    int? petId,
    String? bookingType,
    DateTime? scheduleDate,
    String? notes,
    String? status,
    DateTime? createdAt,
  }) {
    return Booking(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      clinicId: clinicId ?? this.clinicId,
      petId: petId ?? this.petId,
      bookingType: bookingType ?? this.bookingType,
      scheduleDate: scheduleDate ?? this.scheduleDate,
      notes: notes ?? this.notes,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Booking(id: $id, userId: $userId, clinicId: $clinicId, petId: $petId, bookingType: $bookingType, scheduleDate: $scheduleDate, status: $status)';
  }
}
