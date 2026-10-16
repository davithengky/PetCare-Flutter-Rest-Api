import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../core/config/api_config.dart';
import '../../core/errors/app_exception.dart';
import '../../core/services/secure_storage_service.dart';

/// Klien HTTP terpusat untuk seluruh komunikasi dengan REST API PetCare.
///
/// Menangani: penyusunan URL, penyisipan Bearer token, decoding JSON,
/// pemetaan error server menjadi [AppException], serta pembersihan sesi
/// otomatis ketika server membalas `401 Unauthorized`.
class ApiClient {
  ApiClient(this._storage, {http.Client? client})
      : _client = client ?? http.Client();

  final SecureStorageService _storage;
  final http.Client _client;

  static const Map<String, String> _baseHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };

  /// Menyusun header permintaan, termasuk token bila pengguna sudah login.
  Future<Map<String, String>> _headers() async {
    final headers = Map<String, String>.from(_baseHeaders);
    final token = await _storage.getToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  /// Menyusun URI lengkap dari [path] dan [query] opsional.
  Uri _uri(String path, Map<String, dynamic>? query) {
    final normalizedPath = path.startsWith('/') ? path : '/$path';
    final uri = Uri.parse('${ApiConfig.baseUrl}$normalizedPath');

    if (query == null || query.isEmpty) {
      return uri;
    }

    final params = <String, String>{};
    query.forEach((key, value) {
      if (value == null) return;
      final text = value.toString();
      if (text.isEmpty) return;
      params[key] = text;
    });

    if (params.isEmpty) return uri;
    return uri.replace(queryParameters: params);
  }

  /// GET request.
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) {
    return _send(() async {
      final res = await _client.get(
        _uri(path, query),
        headers: await _headers(),
      );
      return res;
    });
  }

  /// POST request.
  Future<dynamic> post(String path, {Map<String, dynamic>? body}) {
    return _send(() async {
      final res = await _client.post(
        _uri(path, null),
        headers: await _headers(),
        body: jsonEncode(body ?? const <String, dynamic>{}),
      );
      return res;
    });
  }

  /// PUT request.
  Future<dynamic> put(String path, {Map<String, dynamic>? body}) {
    return _send(() async {
      final res = await _client.put(
        _uri(path, null),
        headers: await _headers(),
        body: jsonEncode(body ?? const <String, dynamic>{}),
      );
      return res;
    });
  }

  /// PATCH request.
  Future<dynamic> patch(String path, {Map<String, dynamic>? body}) {
    return _send(() async {
      final res = await _client.patch(
        _uri(path, null),
        headers: await _headers(),
        body: jsonEncode(body ?? const <String, dynamic>{}),
      );
      return res;
    });
  }

  /// DELETE request.
  Future<dynamic> delete(String path, {Map<String, dynamic>? body}) {
    return _send(() async {
      final res = await _client.delete(
        _uri(path, null),
        headers: await _headers(),
        body: body == null ? null : jsonEncode(body),
      );
      return res;
    });
  }

  /// Mengeksekusi permintaan, menangani timeout/jaringan, dan mendekode balasan.
  Future<dynamic> _send(Future<http.Response> Function() run) async {
    try {
      final res = await run().timeout(ApiConfig.timeout);

      // Sesi kedaluwarsa: bersihkan kredensial lokal agar konsisten.
      if (res.statusCode == 401) {
        await _storage.clearToken();
        await _storage.clearSession();
      }

      return _decode(res);
    } on TimeoutException {
      throw const AppException(
        'Koneksi ke server timeout. Silakan coba lagi.',
      );
    } on http.ClientException {
      throw const AppException(
        'Tidak dapat terhubung ke server. Periksa koneksi Anda.',
      );
    } on FormatException {
      throw const AppException('Format data dari server tidak dikenali.');
    }
  }

  /// Mendekode body JSON dan mengubah status non-2xx menjadi [AppException].
  dynamic _decode(http.Response res) {
    dynamic decoded;
    if (res.body.isNotEmpty) {
      try {
        decoded = jsonDecode(res.body);
      } on FormatException {
        decoded = null;
      }
    }

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return decoded;
    }

    throw _toException(res.statusCode, decoded);
  }

  /// Memetakan balasan error server menjadi [AppException] berbahasa Indonesia.
  AppException _toException(int status, dynamic decoded) {
    var message = 'Terjadi kesalahan pada server (kode $status)';
    Map<String, dynamic>? errors;

    if (decoded is Map<String, dynamic>) {
      final serverMessage = decoded['message'];
      if (serverMessage is String && serverMessage.isNotEmpty) {
        message = serverMessage;
      }

      final serverErrors = decoded['errors'];
      if (serverErrors is Map<String, dynamic>) {
        errors = serverErrors;
        // Tampilkan pesan validasi pertama bila belum ada pesan khusus.
        if (serverMessage == null || serverMessage.toString().isEmpty) {
          final first = serverErrors.values
              .whereType<List<dynamic>>()
              .expand((e) => e)
              .whereType<String>();
          if (first.isNotEmpty) message = first.first;
        }
      }
    }

    if (status == 401) {
      message = 'Sesi Anda telah berakhir. Silakan login kembali.';
    } else if (status == 403) {
      message = 'Anda tidak memiliki akses untuk tindakan ini.';
    } else if (status == 404) {
      message = 'Data yang diminta tidak ditemukan.';
    }

    return AppException.validation(message: message, errors: errors);
  }

  /// Menutup koneksi HTTP.
  void dispose() => _client.close();
}

/// Provider dependency injection untuk layanan Secure Storage.
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// Provider dependency injection untuk [ApiClient].
final apiClientProvider = Provider<ApiClient>((ref) {
  final client = ApiClient(ref.watch(secureStorageProvider));
  ref.onDispose(client.dispose);
  return client;
});
