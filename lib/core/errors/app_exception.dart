/// Kelas exception standar untuk menangani kesalahan pada aplikasi PetCare.
class AppException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  const AppException(
    this.message, {
    this.errors,
  });

  /// Factory untuk error validasi input
  factory AppException.validation({
    required String message,
    Map<String, dynamic>? errors,
  }) {
    return AppException(message, errors: errors);
  }

  /// Factory untuk error tidak terduga/unknown
  factory AppException.unknown([String? message]) {
    return AppException(message ?? 'Terjadi kesalahan yang tidak diketahui');
  }

  @override
  String toString() => message;
}
