import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/services/notification_service.dart';

/// Titik masuk (entry point) utama aplikasi PetCare.
void main() async {
  // Memastikan binding Flutter telah terinisialisasi sebelum menjalankan service/aplikasi
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi data locale intl (format tanggal/mata uang) untuk id_ID
  await initializeDateFormatting();

  // Inisialisasi awal SharedPreferences untuk persistensi lokal
  await SharedPreferences.getInstance();

  // Inisialisasi layanan notifikasi lokal untuk pengingat vaksin & obat
  await NotificationService().init();

  // Menjalankan aplikasi di dalam cakupan Riverpod (ProviderScope)
  runApp(
    const ProviderScope(
      child: PetCareApp(),
    ),
  );
}
