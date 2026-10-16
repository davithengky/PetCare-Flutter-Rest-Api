import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Layanan penyimpanan aman untuk sesi pengguna menggunakan FlutterSecureStorage.
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _keyUserId = 'user_id';
  static const String _keyName = 'user_name';
  static const String _keyEmail = 'user_email';
  static const String _keyMembershipTier = 'user_membership_tier';
  static const String _keyAuthToken = 'auth_token';

  /// Menyimpan data sesi login pengguna ke secure storage.
  Future<void> saveSession({
    required int userId,
    required String name,
    required String email,
    required String membershipTier,
  }) async {
    await _storage.write(key: _keyUserId, value: userId.toString());
    await _storage.write(key: _keyName, value: name);
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyMembershipTier, value: membershipTier);
  }

  /// Mengambil data sesi pengguna jika tersedia.
  Future<Map<String, String>?> getSession() async {
    final userId = await _storage.read(key: _keyUserId);
    if (userId == null) {
      return null;
    }

    final name = await _storage.read(key: _keyName) ?? '';
    final email = await _storage.read(key: _keyEmail) ?? '';
    final membershipTier =
        await _storage.read(key: _keyMembershipTier) ?? 'basic';

    return {
      'userId': userId,
      'name': name,
      'email': email,
      'membershipTier': membershipTier,
    };
  }

  /// Memeriksa apakah sesi login pengguna masih tersimpan.
  Future<bool> hasSession() async {
    final userId = await _storage.read(key: _keyUserId);
    return userId != null && userId.isNotEmpty;
  }

  /// Menghapus seluruh data sesi login dari secure storage.
  Future<void> clearSession() async {
    await _storage.delete(key: _keyUserId);
    await _storage.delete(key: _keyName);
    await _storage.delete(key: _keyEmail);
    await _storage.delete(key: _keyMembershipTier);
  }

  /// Menyimpan token Sanctum hasil login/registrasi.
  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyAuthToken, value: token);
  }

  /// Mengambil token Sanctum yang tersimpan (null bila belum login).
  Future<String?> getToken() async {
    final token = await _storage.read(key: _keyAuthToken);
    if (token == null || token.isEmpty) {
      return null;
    }
    return token;
  }

  /// Menghapus token Sanctum.
  Future<void> clearToken() async {
    await _storage.delete(key: _keyAuthToken);
  }
}
