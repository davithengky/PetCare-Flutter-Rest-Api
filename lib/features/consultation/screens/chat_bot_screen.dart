import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/chat_provider.dart';

/// Layar chat bot PetBot — asisten virtual untuk pertanyaan seputar hewan peliharaan.
class ChatBotScreen extends ConsumerStatefulWidget {
  const ChatBotScreen({super.key});

  @override
  ConsumerState<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends ConsumerState<ChatBotScreen> {
  int? consultationId;
  bool isInitializing = true;

  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mulai sesi chat setelah frame pertama selesai dirender
    WidgetsBinding.instance.addPostFrameCallback((_) => _initChat());
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Inisialisasi sesi chat: buat consultation baru via provider.
  Future<void> _initChat() async {
    final user = ref.read(authProvider).value?.user;

    if (user == null) {
      if (mounted) context.go('/login');
      return;
    }

    final consultation = await ref
        .read(startConsultationProvider.notifier)
        .start(userId: user.id);

    if (consultation != null && mounted) {
      setState(() {
        consultationId = consultation.id;
        isInitializing = false;
      });
    }
  }

  /// Mengirim pesan pengguna ke repositori dan mengosongkan input field.
  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || consultationId == null) return;

    final user = ref.read(authProvider).value?.user;
    if (user == null) return;

    _controller.clear();

    await ref.read(consultationRepoProvider).sendMessage(
          consultationId: consultationId!,
          senderId: user.id,
          senderType: 'user',
          text: text,
        );

    _scrollToBottom();
  }

  /// Animasi scroll ke pesan terbaru di bagian bawah daftar chat.
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Auto-scroll setiap kali ada pesan baru
    if (consultationId != null) {
      ref.listen(chatMessagesProvider(consultationId!), (_, _) {
        _scrollToBottom();
      });
    }

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            // Avatar PetBot
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.accentBlue.withValues(alpha: 0.15),
              child: const Icon(
                Icons.smart_toy_rounded,
                color: AppColors.accentBlue,
                size: 22,
              ),
            ),
            const SizedBox(width: AppSizes.md),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'PetBot',
                  style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
                ),
                Text(
                  'PetCare Vet Clinic • Online',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.accentGreen,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.grey700),
            onPressed: () {},
          ),
        ],
      ),
      body: isInitializing ? _buildLoadingState() : _buildChatBody(),
    );
  }

  /// Tampilan loading saat sesi sedang diinisialisasi.
  Widget _buildLoadingState() {
    return const LoadingWidget(message: 'Menghubungkan ke PetBot...');
  }

  /// Tampilan utama area chat dan input pesan.
  Widget _buildChatBody() {
    return Column(
      children: [
        // 1. Area daftar pesan
        Expanded(
          child: ref.watch(chatMessagesProvider(consultationId!)).when(
                loading: () =>
                    const LoadingWidget(message: 'Memuat percakapan...'),
                error: (err, _) => CustomErrorWidget(
                  message: 'Gagal memuat percakapan: $err',
                  onRetry: () =>
                      ref.invalidate(chatMessagesProvider(consultationId!)),
                ),
                data: (messages) {
                  if (messages.isEmpty) {
                    return Center(
                      child: Text(
                        'Mulai percakapan...',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey500,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSizes.lg,
                      horizontal: AppSizes.lg,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isUser = message.senderType == 'user';
                      return _buildBubble(message.text, isUser, message.createdAt);
                    },
                  );
                },
              ),
        ),

        // 2. Input pesan bawah
        Container(
          padding: const EdgeInsets.all(AppSizes.md),
          decoration: const BoxDecoration(
            color: AppColors.white,
            border: Border(top: BorderSide(color: AppColors.grey200)),
          ),
          child: SafeArea(
            top: false,
            child: Row(
              children: [
                // Text field
                Expanded(
                  child: TextField(
                    controller: _controller,
                    style: AppTextStyles.body,
                    minLines: 1,
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ketik pesan...',
                      hintStyle: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.grey500,
                      ),
                      filled: true,
                      fillColor: AppColors.grey100,
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: AppSizes.md,
                        horizontal: AppSizes.lg,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.xl),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSizes.sm),

                // Tombol kirim
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryTeal,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.send_rounded,
                      color: AppColors.white,
                      size: 20,
                    ),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Membangun satu bubble percakapan.
  Widget _buildBubble(String text, bool isUser, DateTime createdAt) {
    final timeStr = DateFormat('HH:mm').format(createdAt);
    final maxWidth = MediaQuery.sizeOf(context).width * 0.72;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.md),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // Bubble
            Container(
              constraints: BoxConstraints(maxWidth: maxWidth),
              padding: const EdgeInsets.symmetric(
                vertical: AppSizes.md,
                horizontal: AppSizes.lg,
              ),
              decoration: BoxDecoration(
                color: isUser ? AppColors.primaryTeal : AppColors.white,
                border: isUser ? null : Border.all(color: AppColors.grey300),
                borderRadius: isUser
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.lg),
                        topRight: Radius.circular(AppRadius.lg),
                        bottomLeft: Radius.circular(AppRadius.lg),
                        bottomRight: Radius.circular(4),
                      )
                    : const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.lg),
                        topRight: Radius.circular(AppRadius.lg),
                        bottomLeft: Radius.circular(4),
                        bottomRight: Radius.circular(AppRadius.lg),
                      ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                text,
                style: AppTextStyles.body.copyWith(
                  color: isUser ? AppColors.white : AppColors.grey900,
                ),
              ),
            ),

            const SizedBox(height: 4),

            // Waktu pesan
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                timeStr,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.grey500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
