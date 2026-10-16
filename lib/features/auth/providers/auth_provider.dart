import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/errors/app_exception.dart';
import '../../../data/api/api_client.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/api_auth_repo.dart';
import '../../../data/repositories/auth_repo.dart';

/// State untuk fitur autentikasi.
class AuthState {
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Status apakah user sudah login
  bool get isLoggedIn => user != null;

  /// Salinan AuthState dengan modifikasi nilai tertentu
  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? errorMessage,
    bool clearUser = false,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

/// Provider dependency injection untuk repository autentikasi.
final authRepoProvider = Provider<AuthRepo>((ref) {
  return ApiAuthRepo(
    ref.watch(apiClientProvider),
    ref.watch(secureStorageProvider),
  );
});

/// Notifier untuk mengelola state autentikasi menggunakan AsyncNotifier (Riverpod 3.x)
class AuthNotifier extends AsyncNotifier<AuthState> {
  @override
  Future<AuthState> build() async {
    // Memeriksa apakah ada sesi login yang tersimpan di secure storage
    final session = await ref.read(secureStorageProvider).getSession();
    if (session != null) {
      final userId = int.tryParse(session['userId'] ?? '1') ?? 1;
      final user = User(
        id: userId,
        name: session['name'] ?? '',
        email: session['email'] ?? '',
        membershipTier: session['membershipTier'] ?? 'basic',
      );
      return AuthState(user: user, isLoading: false);
    }
    return const AuthState(user: null, isLoading: false);
  }

  /// Melakukan login dengan email & password
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    state = AsyncData(
      state.value?.copyWith(isLoading: true, clearError: true) ??
          const AuthState(isLoading: true),
    );

    try {
      final repo = ref.read(authRepoProvider);
      final user = await repo.login(email: email, password: password);

      // Simpan session ke storage
      await ref.read(secureStorageProvider).saveSession(
            userId: user.id,
            name: user.name,
            email: user.email,
            membershipTier: user.membershipTier,
          );

      state = AsyncData(AuthState(user: user, isLoading: false));
      return true;
    } on AppException catch (e) {
      state = AsyncData(
        state.value?.copyWith(
              isLoading: false,
              errorMessage: e.message,
            ) ??
            AuthState(isLoading: false, errorMessage: e.message),
      );
      return false;
    } catch (_) {
      const errorMsg = 'Terjadi kesalahan yang tidak terduga';
      state = AsyncData(
        state.value?.copyWith(
              isLoading: false,
              errorMessage: errorMsg,
            ) ??
            const AuthState(isLoading: false, errorMessage: errorMsg),
      );
      return false;
    }
  }

  /// Mendaftarkan akun baru
  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncData(
      state.value?.copyWith(isLoading: true, clearError: true) ??
          const AuthState(isLoading: true),
    );

    try {
      final repo = ref.read(authRepoProvider);
      final user = await repo.register(
        name: name,
        email: email,
        password: password,
      );

      // Simpan session ke storage
      await ref.read(secureStorageProvider).saveSession(
            userId: user.id,
            name: user.name,
            email: user.email,
            membershipTier: user.membershipTier,
          );

      state = AsyncData(AuthState(user: user, isLoading: false));
      return true;
    } on AppException catch (e) {
      state = AsyncData(
        state.value?.copyWith(
              isLoading: false,
              errorMessage: e.message,
            ) ??
            AuthState(isLoading: false, errorMessage: e.message),
      );
      return false;
    } catch (_) {
      const errorMsg = 'Terjadi kesalahan saat pendaftaran akun';
      state = AsyncData(
        state.value?.copyWith(
              isLoading: false,
              errorMessage: errorMsg,
            ) ??
            const AuthState(isLoading: false, errorMessage: errorMsg),
      );
      return false;
    }
  }

  /// Keluar dari akun (logout)
  Future<void> logout() async {
    state = AsyncData(
      state.value?.copyWith(isLoading: true) ??
          const AuthState(isLoading: true),
    );

    try {
      await ref.read(authRepoProvider).logout();
      await ref.read(secureStorageProvider).clearSession();
    } finally {
      state = const AsyncData(AuthState(user: null, isLoading: false));
    }
  }

  /// Memperbarui data pengguna dan menyimpan ke secure storage
  void updateUser(User newUser) {
    final currentState = state.value;
    if (currentState == null) return;
    state = AsyncData(currentState.copyWith(user: newUser));
    ref.read(secureStorageProvider).saveSession(
          userId: newUser.id,
          name: newUser.name,
          email: newUser.email,
          membershipTier: newUser.membershipTier,
        );
  }
}


/// Provider global untuk AuthNotifier
final authProvider =
    AsyncNotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
