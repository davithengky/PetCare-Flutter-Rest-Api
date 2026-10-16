import 'package:flutter/foundation.dart';

/// Konfigurasi alamat dasar (base URL) REST API PetCare.
///
/// Nilai dapat ditimpa saat build/run tanpa mengubah kode:
/// ```
/// flutter run --dart-define=API_BASE_URL=http://192.168.1.10:8000/api
/// ```
class ApiConfig {
  const ApiConfig._();

  /// Nilai override dari `--dart-define` (kosong bila tidak diisi).
  static const String _overrideBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
  );

  /// Alamat default backend `php artisan serve`.
  ///
  /// Android Emulator tidak dapat mengakses `127.0.0.1` host secara langsung,
  /// sehingga dipetakan ke `10.0.2.2`. Perangkat fisik dapat memakai
  /// `--dart-define=API_BASE_URL=http://<IP-LAN>:8000/api`.
  static String get baseUrl {
    if (_overrideBaseUrl.isNotEmpty) {
      return _overrideBaseUrl;
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }

    return 'http://127.0.0.1:8000/api';
  }

  /// Batas waktu setiap permintaan HTTP.
  static const Duration timeout = Duration(seconds: 20);
}
