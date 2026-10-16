import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';

/// Halaman Kebijakan Privasi PetCare Vet Clinic.
class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kebijakan Privasi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Kebijakan Privasi PetCare Vet Clinic',
              style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Terakhir diperbarui: 1 Januari 2025',
              style: AppTextStyles.caption.copyWith(color: AppColors.grey500),
            ),
            const SizedBox(height: AppSizes.sectionGap),

            _buildSection(
              title: '1. Informasi yang Kami Kumpulkan',
              content:
                  'Kami mengumpulkan informasi yang kamu berikan langsung secara sukarela saat pendaftaran dan penggunaan aplikasi, termasuk: nama lengkap, alamat email, nomor telepon, alamat domisili pengiriman, serta data anabul peliharaan (nama, jenis spesies, ras, tanggal lahir, dan berat badan).',
            ),
            _buildSection(
              title: '2. Penggunaan Informasi',
              content:
                  'Informasi yang dikumpulkan digunakan semata-mata untuk memproses reservasi/booking klinik cabang, memproses dan mengirimkan pesanan kebutuhan hewan, mengingatkan jadwal vaksin atau obat secara otomatis, serta meningkatkan kualitas pelayanan klinik PetCare.',
            ),
            _buildSection(
              title: '3. Keamanan Data',
              content:
                  'Kami menerapkan standar enkripsi modern untuk menjaga kerahasiaan data sensitif Anda. Data kata sandi (password) disimpan dalam bentuk hash terenkripsi dan tidak pernah diakses atau dibagikan dalam bentuk teks terbuka.',
            ),
            _buildSection(
              title: '4. Berbagi Informasi kepada Pihak Ketiga',
              content:
                  'PetCare Vet Clinic tidak menjual, memperdagangkan, atau menyewakan informasi pribadi Anda kepada pihak mana pun. Data alamat dan nomor telepon hanya diteruskan kepada kurir pengiriman resmi untuk pengantaran produk pesanan Anda.',
            ),
            _buildSection(
              title: '5. Hak Pemilik Akun',
              content:
                  'Anda memiliki hak penuh untuk memeriksa, memperbarui, atau mengajukan permohonan penghapusan seluruh data pribadi Anda dari server kami kapan saja melalui menu pengaturan akun atau layanan pelanggan kami.',
            ),
            _buildSection(
              title: '6. Kontak Kami',
              content:
                  'Apabila Anda memiliki pertanyaan, saran, atau keluhan seputar kebijakan perlindungan data pribadi ini, silakan hubungi tim kepatuhan kami melalui email: privacy@petcare.id.',
            ),
            const SizedBox(height: AppSizes.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSizes.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
          ),
          const SizedBox(height: 6),
          Text(
            content,
            style: AppTextStyles.body.copyWith(
              color: AppColors.grey700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
