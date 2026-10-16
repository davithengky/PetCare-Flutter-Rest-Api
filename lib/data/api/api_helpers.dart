/// Utilitas kecil untuk membaca bentuk balasan REST API PetCare.
///
/// Backend mengembalikan koleksi dalam bentuk `{ "data": [...] }` (termasuk
/// saat berpaginasi) dan resource tunggal dalam bentuk `{ "data": {...} }`.
library;

/// Mengambil daftar objek dari balasan API.
///
/// Mendukung `{ "data": [...] }` maupun array langsung. Mengembalikan
/// daftar kosong bila bentuk balasan tidak dikenali.
List<Map<String, dynamic>> apiList(dynamic response) {
  final raw = response is Map<String, dynamic> ? response['data'] : response;
  if (raw is List) {
    return raw.whereType<Map<String, dynamic>>().toList();
  }
  return const [];
}

/// Mengambil satu objek dari balasan API.
///
/// Mendukung `{ "data": {...} }` maupun objek langsung. Mengembalikan map
/// kosong bila balasan tidak berisi objek.
Map<String, dynamic> apiMap(dynamic response) {
  if (response is Map<String, dynamic>) {
    final data = response['data'];
    if (data is Map<String, dynamic>) {
      return data;
    }
    return response;
  }
  return const <String, dynamic>{};
}

/// Mengambil pesan balasan server (`message`) bila ada.
String? apiMessage(dynamic response) {
  if (response is Map<String, dynamic>) {
    final message = response['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
  }
  return null;
}
