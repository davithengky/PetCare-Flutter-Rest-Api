import '../models/user_model.dart';

/// Kontrak repository untuk fitur autentikasi pengguna.
abstract class AuthRepo {
  /// Melakukan login dengan email dan password.
  Future<User> login({
    required String email,
    required String password,
  });

  /// Melakukan pendaftaran akun baru.
  Future<User> register({
    required String name,
    required String email,
    required String password,
  });

  /// Memperbarui data profil pengguna (nama, telepon, alamat).
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? address,
  });

  /// Mengakhiri sesi pengguna saat ini.
  Future<void> logout();
}
