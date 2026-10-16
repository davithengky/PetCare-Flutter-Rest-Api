import 'dart:async';

import '../api/api_client.dart';
import '../api/api_helpers.dart';
import '../models/consultation_model.dart';
import '../models/message_model.dart';
import 'consultation_repo.dart';

/// Implementasi [ConsultationRepo] yang terhubung ke REST API PetCare.
///
/// Karena backend tidak menyediakan kanal realtime (websocket), pesan
/// didorong ke stream setiap kali riwayat dimuat atau pesan baru dikirim.
class ApiConsultationRepo implements ConsultationRepo {
  ApiConsultationRepo(this._client);

  final ApiClient _client;

  final Map<int, List<Message>> _messages = {};
  final Map<int, StreamController<List<Message>>> _controllers = {};

  StreamController<List<Message>> _controllerFor(int consultationId) {
    final existing = _controllers[consultationId];
    if (existing != null && !existing.isClosed) {
      return existing;
    }
    final controller = StreamController<List<Message>>.broadcast();
    _controllers[consultationId] = controller;
    return controller;
  }

  /// Mendukung snapshot pesan terbaru ke stream (bila masih terbuka).
  void _push(int consultationId) {
    final controller = _controllers[consultationId];
    if (controller == null || controller.isClosed) return;
    controller.add(List.unmodifiable(_messages[consultationId] ?? const []));
  }

  @override
  Future<Consultation> startConsultation({required int userId}) async {
    final res = await _client.post('/consultations', body: {'type': 'bot'});
    return Consultation.fromJson(apiMap(res));
  }

  @override
  Future<List<Consultation>> getUserConsultations(int userId) async {
    final res = await _client.get('/consultations');
    return apiList(res).map(Consultation.fromJson).toList();
  }

  @override
  Future<Consultation?> getConsultationById(int id) async {
    final res = await _client.get('/consultations/$id');
    final map = apiMap(res);
    return map.isEmpty ? null : Consultation.fromJson(map);
  }

  @override
  Future<void> endConsultation(int id) async {
    await _client.patch('/consultations/$id/end');
  }

  @override
  Stream<List<Message>> streamMessages(int consultationId) {
    final controller = _controllerFor(consultationId);
    // Muat riwayat dari server lalu dorong ke stream.
    _loadMessages(consultationId);
    return controller.stream;
  }

  /// Mengambil seluruh pesan sesi dari server dan mendorongnya ke stream.
  Future<void> _loadMessages(int consultationId) async {
    try {
      final res = await _client.get('/consultations/$consultationId/messages');
      _messages[consultationId] =
          apiList(res).map(Message.fromJson).toList();
    } catch (_) {
      _messages.putIfAbsent(consultationId, () => []);
    }
    _push(consultationId);
  }

  @override
  Future<void> sendMessage({
    required int consultationId,
    required int senderId,
    required String senderType,
    required String text,
  }) async {
    final res = await _client.post(
      '/consultations/$consultationId/messages',
      body: {'text': text},
    );

    final list = _messages.putIfAbsent(consultationId, () => []);

    if (res is Map<String, dynamic>) {
      final userMessage = res['data'];
      if (userMessage is Map<String, dynamic>) {
        list.add(Message.fromJson(userMessage));
      }
      final reply = res['reply'];
      if (reply is Map<String, dynamic>) {
        list.add(Message.fromJson(reply));
      }
    }

    _push(consultationId);
  }

  @override
  Future<void> dispose() async {
    for (final controller in _controllers.values) {
      if (!controller.isClosed) {
        await controller.close();
      }
    }
    _controllers.clear();
    _messages.clear();
  }
}
