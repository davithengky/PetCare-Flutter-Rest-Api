import 'dart:async';

import '../models/consultation_model.dart';
import '../models/message_model.dart';
import '../services/chat_bot_service.dart';
import 'consultation_repo.dart';

/// Implementasi in-memory mock repository untuk sesi chat bot PetBot.
class MockConsultationRepo implements ConsultationRepo {
  final List<Consultation> _consultations = [];
  int _nextConsultationId = 1;

  final Map<int, List<Message>> _messagesByConsultation = {};
  int _nextMessageId = 1;

  final Map<int, StreamController<List<Message>>> _streamControllers = {};

  // Pesan sambutan PetBot saat sesi dimulai
  static const String _welcomeMessage = ChatBotService.welcomeMessage;

  /// Mengambil atau membuat StreamController broadcast untuk [consultationId].
  StreamController<List<Message>> _getOrCreateController(int consultationId) {
    if (!_streamControllers.containsKey(consultationId) ||
        _streamControllers[consultationId]!.isClosed) {
      _streamControllers[consultationId] =
          StreamController<List<Message>>.broadcast();
    }
    return _streamControllers[consultationId]!;
  }

  @override
  Future<Consultation> startConsultation({required int userId}) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final consultation = Consultation(
      id: _nextConsultationId++,
      userId: userId,
      botName: 'PetBot PetCare',
      status: 'active',
      startedAt: DateTime.now(),
    );

    _consultations.add(consultation);
    _messagesByConsultation[consultation.id] = [];

    // Buat stream controller lebih awal agar siap menerima listener
    _getOrCreateController(consultation.id);

    // Kirim pesan sambutan dari bot dengan sedikit jeda
    Future.delayed(const Duration(milliseconds: 600), () {
      _addBotMessage(consultation.id, _welcomeMessage);
    });

    return consultation;
  }

  @override
  Future<List<Consultation>> getUserConsultations(int userId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _consultations.where((c) => c.userId == userId).toList();
  }

  @override
  Future<Consultation?> getConsultationById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _consultations.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> endConsultation(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _consultations.indexWhere((c) => c.id == id);
    if (index != -1) {
      _consultations[index] = _consultations[index].copyWith(
        status: 'completed',
        endedAt: () => DateTime.now(),
      );
    }
  }

  @override
  Stream<List<Message>> streamMessages(int consultationId) {
    final controller = _getOrCreateController(consultationId);
    final messages = _messagesByConsultation[consultationId] ?? [];

    // Push data pesan yang sudah ada secara asinkron agar langsung diterima listener
    Future.microtask(() {
      if (!controller.isClosed) {
        controller.add(List.unmodifiable(messages));
      }
    });

    return controller.stream;
  }

  @override
  Future<void> sendMessage({
    required int consultationId,
    required int senderId,
    required String senderType,
    required String text,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final list = _messagesByConsultation.putIfAbsent(consultationId, () => []);

    // 1. Simpan dan push pesan dari pengguna
    final userMessage = Message(
      id: _nextMessageId++,
      consultationId: consultationId,
      senderId: senderId,
      senderType: senderType,
      text: text,
      createdAt: DateTime.now(),
    );

    list.add(userMessage);
    _pushToStream(consultationId, list);

    // 2. Simulasi jeda bot mengetik (1.2 detik) lalu kirim balasan
    if (senderType == 'user') {
      await Future.delayed(const Duration(milliseconds: 1200));

      final replyText = ChatBotService.getReply(text);
      _addBotMessage(consultationId, replyText);
    }
  }

  /// Helper: menambah pesan bot ke list dan push ke stream.
  void _addBotMessage(int consultationId, String text) {
    final list = _messagesByConsultation.putIfAbsent(consultationId, () => []);

    final botMessage = Message(
      id: _nextMessageId++,
      consultationId: consultationId,
      senderId: 0, // ID 0 dipakai untuk PetBot
      senderType: 'bot',
      text: text,
      createdAt: DateTime.now(),
    );

    list.add(botMessage);
    _pushToStream(consultationId, list);
  }

  /// Helper: mendorong snapshot terbaru ke StreamController.
  void _pushToStream(int consultationId, List<Message> list) {
    final controller = _streamControllers[consultationId];
    if (controller != null && !controller.isClosed) {
      controller.add(List.unmodifiable(list));
    }
  }

  @override
  Future<void> dispose() async {
    for (final controller in _streamControllers.values) {
      if (!controller.isClosed) {
        await controller.close();
      }
    }
    _streamControllers.clear();
  }
}
