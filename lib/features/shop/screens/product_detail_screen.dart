import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

/// Halaman detail informasi produk Pet Shop.
class ProductDetailScreen extends ConsumerWidget {
  final int productId;

  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(productByIdProvider(productId));
    final cartCount = ref.watch(cartCountProvider);

    return productAsync.when(
      loading: () => const Scaffold(
        body: LoadingWidget(message: 'Memuat detail produk...'),
      ),
      error: (err, _) => Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: CustomErrorWidget(
          message: 'Gagal memuat produk: $err',
          onRetry: () => ref.refresh(productByIdProvider(productId)),
        ),
      ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Detail Produk')),
            body: const Center(child: Text('Produk tidak ditemukan')),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: Text(
              'Detail Produk',
              style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
            ),
            backgroundColor: AppColors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
              onPressed: () => context.pop(),
            ),
            actions: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.shopping_cart_outlined,
                      color: AppColors.grey900,
                      size: 26,
                    ),
                    onPressed: () => context.push('/shop/cart'),
                  ),
                  if (cartCount > 0)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: AppColors.accentRed,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            cartCount > 99 ? '99+' : '$cartCount',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: AppSizes.sm),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Utama Produk Placeholder
                      AspectRatio(
                        aspectRatio: 1.1,
                        child: AppImage(
                          url: product.imageUrl,
                          fallbackIcon: Icons.pets,
                          fallbackIconSize: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      // Informasi & Harga
                      Padding(
                        padding: const EdgeInsets.all(AppSizes.screenPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.category.toUpperCase(),
                              style: AppTextStyles.overline.copyWith(
                                color: AppColors.accentOrange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              product.name,
                              style: AppTextStyles.h2.copyWith(
                                color: AppColors.grey900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 16,
                                  color: AppColors.accentYellow,
                                ),
                                Text(
                                  ' ${product.rating.toStringAsFixed(1)}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey900,
                                  ),
                                ),
                                Text(
                                  ' • ${product.soldCount} terjual',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.grey500,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Harga
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.baseline,
                              textBaseline: TextBaseline.alphabetic,
                              children: [
                                Text(
                                  CurrencyFormatter.format(product.price),
                                  style: AppTextStyles.display.copyWith(
                                    color: AppColors.primaryTeal,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                if (product.isDiscounted &&
                                    product.originalPrice != null) ...[
                                  const SizedBox(width: 12),
                                  Text(
                                    CurrencyFormatter.format(
                                        product.originalPrice!),
                                    style: AppTextStyles.bodyLarge.copyWith(
                                      color: AppColors.grey500,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(color: AppColors.grey200),
                            const SizedBox(height: 16),

                            // Deskripsi
                            Text(
                              'Deskripsi Produk',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.grey900,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              product.description ??
                                  'Tidak ada deskripsi untuk produk ini.',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.grey700,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Stok
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSizes.md,
                                vertical: AppSizes.sm,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.grey100,
                                borderRadius:
                                    BorderRadius.circular(AppRadius.md),
                              ),
                              child: Text(
                                'Stok tersedia: ${product.stock} pcs',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.grey700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.all(AppSizes.screenPadding),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  border: const Border(
                    top: BorderSide(color: AppColors.grey200),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Row(
                    children: [
                      // Tombol Tambah ke Keranjang
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .addItem(product, quantity: 1);
                            SnackbarHelper.success(
                              context,
                              '${product.name} ditambahkan ke keranjang!',
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 48),
                            side: const BorderSide(
                              color: AppColors.primaryTeal,
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.btn),
                            ),
                          ),
                          child: Text(
                            '+ Keranjang',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Tombol Beli Sekarang
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            ref
                                .read(cartProvider.notifier)
                                .addItem(product, quantity: 1);
                            context.push('/shop/cart');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            foregroundColor: AppColors.white,
                            minimumSize: const Size(double.infinity, 48),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppRadius.btn),
                            ),
                          ),
                          child: Text(
                            'Beli Sekarang',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
