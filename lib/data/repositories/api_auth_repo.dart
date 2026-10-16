import '../../core/errors/app_exception.dart';
import '../../core/services/secure_storage_service.dart';
import '../api/api_client.dart';
import '../models/user_model.dart';
import 'auth_repo.dart';

/// Implementasi [AuthRepo] yang terhubung ke REST API PetCare (Sanctum).
class ApiAuthRepo implements AuthRepo {
  ApiAuthRepo(this._client, this._storage);

  final ApiClient _client;
  final SecureStorageService _storage;

  @override
  Future<User> login({
    required String email,
    required String password,
  }) async {
    final res = await _client.post(
      '/login',
      body: {'email': email.trim(), 'password': password},
    );
    return _persistSession(res);
  }

  @override
  Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final res = await _client.post(
      '/register',
      body: {
        'name': name.trim(),
        'email': email.trim(),
        'password': password,
      },
    );
    return _persistSession(res);
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    final body = <String, dynamic>{};
    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    if (address != null) body['address'] = address;

    final res = await _client.put('/profile', body: body);
    final userJson = res is Map<String, dynamic>
        ? res['user']
        : null;

    if (userJson is! Map<String, dynamic>) {
      throw const AppException('Gagal memperbarui profil pengguna');
    }

    return User.fromJson(userJson);
  }

  @override
  Future<void> logout() async {
    try {
      await _client.post('/logout');
    } on AppException {
      // Token mungkin sudah kedaluwarsa; sesi lokal tetap dibersihkan.
    } finally {
      await _storage.clearToken();
    }
  }

  /// Menyimpan token Sanctum lalu membangun objek [User] dari balasan auth.
  Future<User> _persistSession(dynamic res) async {
    final map = res is Map<String, dynamic> ? res : const <String, dynamic>{};

    final token = map['token'];
    if (token is String && token.isNotEmpty) {
      await _storage.saveToken(token);
    }

    final userJson = map['user'];
    if (userJson is! Map<String, dynamic>) {
      throw const AppException('Balasan autentikasi dari server tidak valid');
    }

    return User.fromJson(userJson);
  }
}
