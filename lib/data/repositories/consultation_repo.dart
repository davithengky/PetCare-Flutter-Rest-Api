import '../models/consultation_model.dart';
import '../models/message_model.dart';

/// Kontrak repositori untuk mengelola sesi chat bot PetBot.
abstract class ConsultationRepo {
  /// Memulai sesi chat baru untuk pengguna dengan [userId].
  Future<Consultation> startConsultation({required int userId});

  /// Mengambil daftar sesi chat milik pengguna dengan [userId].
  Future<List<Consultation>> getUserConsultations(int userId);

  /// Mengambil data sesi chat berdasarkan [id].
  Future<Consultation?> getConsultationById(int id);

  /// Mengakhiri sesi chat dengan status 'completed'.
  Future<void> endConsultation(int id);

  /// Mendengarkan stream pesan realtime untuk [consultationId].
  Stream<List<Message>> streamMessages(int consultationId);

  /// Mengirim pesan baru ke sesi chat.
  Future<void> sendMessage({
    required int consultationId,
    required int senderId,
    required String senderType,
    required String text,
  });

  /// Menutup dan membersihkan semua stream atau resource yang digunakan.
  Future<void> dispose();
}
