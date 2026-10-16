import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';

/// Halaman Pusat Bantuan dan Tanya Jawab (FAQ) aplikasi PetCare.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  final List<Map<String, String>> _faqItems = const [
    {
      'question': 'Bagaimana cara menambah anabul?',
      'answer':
          'Buka menu Profil → Anabul Saya → tombol "+ Tambah". Atau dari Beranda, scroll ke bawah dan tap banner onboarding tambah pet.',
    },
    {
      'question': 'Apakah konsultasi chat bot gratis?',
      'answer':
          'Ya, konsultasi dengan PetBot 100% gratis. Untuk pemeriksaan fisik langsung atau penanganan medis darurat, kamu bisa booking cabang PetCare terdekat.',
    },
    {
      'question': 'Bagaimana cara booking klinik?',
      'answer':
          'Dari Beranda, tap kartu "Klinik" → pilih cabang PetCare terdekat → pilih jenis layanan & tanggal jadwal → konfirmasi booking Anda.',
    },
    {
      'question': 'Apa saja metode pembayaran?',
      'answer':
          'Kami menerima pembayaran Cash on Delivery (COD), Transfer Bank Virtual Account, dan E-Wallet (GoPay, OVO, ShopeePay).',
    },
    {
      'question': 'Bagaimana cara batalkan booking?',
      'answer':
          'Buka menu Aktivitas → tap kartu booking Anda → pilih tombol Batalkan. Pembatalan dapat dilakukan minimal 1 hari sebelum jadwal konsultasi.',
    },
    {
      'question': 'Apakah pengiriman produk bisa ke luar kota?',
      'answer':
          'Saat ini kurir toko kami melayani pengiriman area Surabaya, Sidoarjo, dan Gresik dengan garansi produk sampai di hari yang sama.',
    },
    {
      'question': 'Bagaimana cara mengatur pengingat vaksin?',
      'answer':
          'Buka menu Profil → pilih anabul Anda → masuk ke tab "Pengingat" → tap tombol "+ Tambah Pengingat" untuk menjadwalkan notifikasi lokal.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bantuan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'FAQ (Pertanyaan Umum)',
              style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.md),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _faqItems.length,
              separatorBuilder: (_, i) => const SizedBox(height: AppSizes.sm),
              itemBuilder: (context, index) {
                final item = _faqItems[index];
                return Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.grey300),
                  ),
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      dividerColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      collapsedShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                      ),
                      iconColor: AppColors.primaryTeal,
                      collapsedIconColor: AppColors.grey500,
                      title: Text(
                        item['question']!,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.grey900,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            item['answer']!,
                            style: AppTextStyles.body.copyWith(
                              color: AppColors.grey700,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSizes.sectionGap),
            const Divider(),
            const SizedBox(height: AppSizes.lg),
            Text(
              'Hubungi Kami',
              style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.md),
            Container(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                children: [
                  _buildContactChannel(
                    icon: Icons.phone,
                    title: 'Telepon',
                    subtitle: '031-5671234',
                  ),
                  const Divider(height: 24),
                  _buildContactChannel(
                    icon: Icons.email_outlined,
                    title: 'Email',
                    subtitle: 'hello@petcare.id',
                  ),
                  const Divider(height: 24),
                  _buildContactChannel(
                    icon: Icons.chat_bubble_outline,
                    title: 'WhatsApp',
                    subtitle: '0812-3456-7890',
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildContactChannel({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Icon(icon, color: AppColors.primaryTeal, size: 22),
        ),
        const SizedBox(width: AppSizes.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.grey500),
            ),
          ],
        ),
      ],
    );
  }
}
