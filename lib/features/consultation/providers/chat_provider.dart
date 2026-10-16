import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/api/api_client.dart';
import '../../../data/models/consultation_model.dart';
import '../../../data/models/message_model.dart';
import '../../../data/repositories/api_consultation_repo.dart';
import '../../../data/repositories/consultation_repo.dart';

/// Provider instance [ConsultationRepo] untuk sesi chat bot.
final consultationRepoProvider = Provider<ConsultationRepo>((ref) {
  final repo = ApiConsultationRepo(ref.watch(apiClientProvider));
  ref.onDispose(() => repo.dispose());
  return repo;
});

/// Notifier pengelola state sesi chat yang sedang aktif.
class ActiveConsultationNotifier extends Notifier<Consultation?> {
  @override
  Consultation? build() => null;

  void setConsultation(Consultation? consultation) {
    state = consultation;
  }
}

/// Provider sesi chat yang sedang aktif.
final activeConsultationProvider =
    NotifierProvider<ActiveConsultationNotifier, Consultation?>(
  ActiveConsultationNotifier.new,
);

/// StreamProvider untuk mendengarkan perubahan pesan chat realtime berdasarkan [consultationId].
final chatMessagesProvider =
    StreamProvider.family<List<Message>, int>((ref, consultationId) {
  final repo = ref.watch(consultationRepoProvider);
  return repo.streamMessages(consultationId);
});

/// FutureProvider untuk mengambil riwayat sesi chat milik [userId].
final userConsultationsProvider =
    FutureProvider.family<List<Consultation>, int>((ref, userId) async {
  final repo = ref.watch(consultationRepoProvider);
  return repo.getUserConsultations(userId);
});

/// AsyncNotifier untuk aksi memulai sesi chat baru bersama PetBot.
class StartConsultationNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  /// Memulai sesi chat bot dan mengembalikan objek [Consultation].
  Future<Consultation?> start({required int userId}) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(consultationRepoProvider);
      final consultation = await repo.startConsultation(userId: userId);
      ref
          .read(activeConsultationProvider.notifier)
          .setConsultation(consultation);
      state = const AsyncData(null);
      return consultation;
    } catch (e, st) {
      state = AsyncError(e, st);
      return null;
    }
  }
}

/// Provider untuk aksi memulai sesi chat bot.
final startConsultationProvider =
    AsyncNotifierProvider<StartConsultationNotifier, void>(
  StartConsultationNotifier.new,
);
