import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_image.dart';
import '../../../data/models/order_model.dart';

/// Halaman Detail Pesanan — menampilkan semua informasi pesanan secara lengkap.
class OrderDetailScreen extends StatelessWidget {
  final Order order;

  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final fmt = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.grey100,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Card
                  _buildStatusCard(),
                  const SizedBox(height: AppSizes.md),

                  // Info Pesanan
                  _buildInfoCard(fmt),
                  const SizedBox(height: AppSizes.md),

                  // Daftar Produk
                  _buildItemsCard(fmt),
                  const SizedBox(height: AppSizes.md),

                  // Rincian Pembayaran
                  _buildPaymentCard(fmt),
                  const SizedBox(height: AppSizes.md),

                  // Alamat Pengiriman
                  _buildAddressCard(),
                  const SizedBox(height: AppSizes.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 100,
      backgroundColor: AppColors.primaryTeal,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.primaryDark, AppColors.primaryTeal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(
              AppSizes.xxxl + AppSizes.lg, AppSizes.xxxl + AppSizes.md, AppSizes.lg, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detail Pesanan',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              Text(
                '#ORD-${order.id.toString().padLeft(4, '0')}',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final statusConfig = _getStatusConfig(order.status);

    final steps = [
      _StatusStep(
        label: 'Menunggu\nPembayaran',
        icon: Icons.payment_rounded,
        isActive: true,
        isDone: order.status != 'waiting_payment',
      ),
      _StatusStep(
        label: 'Diproses',
        icon: Icons.inventory_2_rounded,
        isActive: ['processing', 'shipped', 'delivered'].contains(order.status),
        isDone: ['shipped', 'delivered'].contains(order.status),
      ),
      _StatusStep(
        label: 'Dikirim',
        icon: Icons.local_shipping_rounded,
        isActive: ['shipped', 'delivered'].contains(order.status),
        isDone: order.status == 'delivered',
      ),
      _StatusStep(
        label: 'Selesai',
        icon: Icons.check_circle_rounded,
        isActive: order.status == 'delivered',
        isDone: order.status == 'delivered',
      ),
    ];

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md, vertical: AppSizes.xs),
                decoration: BoxDecoration(
                  color: statusConfig.bgColor,
                  borderRadius: BorderRadius.circular(AppSizes.xs + 2),
                ),
                child: Text(
                  statusConfig.label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: statusConfig.textColor,
                  ),
                ),
              ),
            ],
          ),
          if (order.status != 'cancelled') ...[
            const SizedBox(height: AppSizes.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps.asMap().entries.map((entry) {
                final step = entry.value;
                final isLast = entry.key == steps.length - 1;
                return Expanded(
                  child: Row(
                    children: [
                      _buildStepIndicator(step),
                      if (!isLast)
                        Expanded(
                          child: Container(
                            height: 2,
                            color: step.isDone
                                ? AppColors.primaryTeal
                                : AppColors.grey200,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppSizes.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps.map((step) {
                return Expanded(
                  child: Text(
                    step.label,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 9,
                      color: step.isActive
                          ? AppColors.primaryTeal
                          : AppColors.grey500,
                      fontWeight: step.isActive
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                );
              }).toList(),
            ),
          ] else ...[
            const SizedBox(height: AppSizes.sm),
            Text(
              'Pesanan ini telah dibatalkan.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.errorText,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepIndicator(_StatusStep step) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: step.isDone
            ? AppColors.primaryTeal
            : step.isActive
                ? AppColors.primaryLight
                : AppColors.grey200,
        shape: BoxShape.circle,
        border: Border.all(
          color: step.isActive ? AppColors.primaryTeal : AppColors.grey300,
          width: 1.5,
        ),
      ),
      child: Icon(
        step.icon,
        size: 14,
        color: step.isDone
            ? AppColors.white
            : step.isActive
                ? AppColors.primaryTeal
                : AppColors.grey500,
      ),
    );
  }

  Widget _buildInfoCard(NumberFormat fmt) {
    return _SectionCard(
      title: 'Informasi Pesanan',
      child: Column(
        children: [
          _InfoRow(label: 'No. Pesanan', value: '#ORD-${order.id.toString().padLeft(4, '0')}'),
          const Divider(height: AppSizes.md, color: AppColors.grey200),
          _InfoRow(
            label: 'Tanggal',
            value: DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(order.createdAt),
          ),
          const Divider(height: AppSizes.md, color: AppColors.grey200),
          _InfoRow(label: 'Total Item', value: '${order.items.length} produk'),
        ],
      ),
    );
  }

  Widget _buildItemsCard(NumberFormat fmt) {
    return _SectionCard(
      title: 'Produk yang Dipesan',
      child: Column(
        children: order.items.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          return Column(
            children: [
              if (i > 0)
                const Divider(height: AppSizes.md, color: AppColors.grey200),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail placeholder
                  AppImage(
                    url: item.imageUrl,
                    width: 52,
                    height: 52,
                    fallbackIcon: Icons.pets,
                    fallbackColor: AppColors.primaryTeal,
                    backgroundColor: AppColors.primaryLight,
                    fallbackIconSize: 24,
                    borderRadius: BorderRadius.circular(AppSizes.sm),
                  ),
                  const SizedBox(width: AppSizes.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.productName,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.grey900,
                          ),
                        ),
                        const SizedBox(height: AppSizes.xs),
                        Text(
                          '${fmt.format(item.priceAtPurchase)} × ${item.quantity}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    fmt.format(item.subtotal),
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPaymentCard(NumberFormat fmt) {
    final subtotal = order.items.fold<double>(0, (sum, i) => sum + i.subtotal);
    const shippingFee = 15000.0;
    final discount = (order.totalAmount - subtotal - shippingFee).clamp(
        double.negativeInfinity, 0.0);

    return _SectionCard(
      title: 'Rincian Pembayaran',
      child: Column(
        children: [
          _InfoRow(label: 'Subtotal produk', value: fmt.format(subtotal)),
          const SizedBox(height: AppSizes.sm),
          _InfoRow(label: 'Biaya pengiriman', value: fmt.format(shippingFee)),
          if (discount < 0) ...[
            const SizedBox(height: AppSizes.sm),
            _InfoRow(
              label: 'Diskon',
              value: '- ${fmt.format(discount.abs())}',
              valueColor: AppColors.successText,
            ),
          ],
          const Divider(height: AppSizes.lg, color: AppColors.grey200),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Bayar',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.grey900,
                ),
              ),
              Text(
                fmt.format(order.totalAmount),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryTeal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard() {
    return _SectionCard(
      title: 'Alamat Pengiriman',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.location_on_rounded,
              color: AppColors.primaryTeal, size: 20),
          const SizedBox(width: AppSizes.sm),
          Expanded(
            child: Text(
              order.shippingAddress,
              style: GoogleFonts.poppins(
                fontSize: 13,
                color: AppColors.grey700,
                height: 1.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: order.shippingAddress));
            },
            child: const Icon(Icons.copy_rounded,
                size: 16, color: AppColors.grey500),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'waiting_payment':
        return const _StatusConfig(
          label: 'Menunggu Pembayaran',
          bgColor: AppColors.warningBg,
          textColor: AppColors.warningText,
        );
      case 'processing':
        return const _StatusConfig(
          label: 'Sedang Diproses',
          bgColor: AppColors.infoBg,
          textColor: AppColors.infoText,
        );
      case 'shipped':
        return const _StatusConfig(
          label: 'Sedang Dikirim',
          bgColor: Color(0xFFE8EAF6),
          textColor: Color(0xFF283593),
        );
      case 'delivered':
        return const _StatusConfig(
          label: 'Selesai',
          bgColor: AppColors.successBg,
          textColor: AppColors.successText,
        );
      case 'cancelled':
        return const _StatusConfig(
          label: 'Dibatalkan',
          bgColor: AppColors.errorBg,
          textColor: AppColors.errorText,
        );
      default:
        return _StatusConfig(
          label: status,
          bgColor: AppColors.grey200,
          textColor: AppColors.grey700,
        );
    }
  }
}

// ─────────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String? title;
  final Widget child;

  const _SectionCard({this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSizes.lg),
        boxShadow: [
          BoxShadow(
            color: AppColors.grey300.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.grey900,
              ),
            ),
            const SizedBox(height: AppSizes.md),
          ],
          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 13, color: AppColors.grey500),
        ),
        const SizedBox(width: AppSizes.md),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: valueColor ?? AppColors.grey900,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusStep {
  final String label;
  final IconData icon;
  final bool isActive;
  final bool isDone;

  const _StatusStep({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.isDone,
  });
}

class _StatusConfig {
  final String label;
  final Color bgColor;
  final Color textColor;

  const _StatusConfig({
    required this.label,
    required this.bgColor,
    required this.textColor,
  });
}
