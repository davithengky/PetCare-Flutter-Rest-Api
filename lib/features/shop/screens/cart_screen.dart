import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../providers/cart_provider.dart';

/// Halaman keranjang belanja (Cart) Pet Shop.
class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          'Keranjang Belanja',
          style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
      ),
      body: cartItems.isEmpty
          ? _buildEmptyState(context)
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(AppSizes.screenPadding),
                    itemCount: cartItems.length,
                    separatorBuilder: (_, _) =>
                        const SizedBox(height: AppSizes.listItemGap),
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      final product = item.product;

                      return Container(
                        padding: const EdgeInsets.all(AppSizes.md),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(AppRadius.card),
                          border: Border.all(color: AppColors.grey300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Foto Produk Placeholder
                            AppImage(
                              url: product.imageUrl,
                              width: 72,
                              height: 72,
                              fallbackIcon: Icons.shopping_bag_outlined,
                              fallbackIconSize: 32,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.md),
                            ),
                            const SizedBox(width: 12),

                            // Detail & Pengatur Kuantitas
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: AppTextStyles.h4.copyWith(
                                      color: AppColors.grey900,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    CurrencyFormatter.format(product.price),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primaryTeal,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      // Pengatur +/-
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.grey300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            AppRadius.chip,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                cartNotifier.updateQuantity(
                                                  product.id,
                                                  item.quantity - 1,
                                                );
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.remove,
                                                  size: 16,
                                                  color: AppColors.grey700,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                              ),
                                              child: Text(
                                                '${item.quantity}',
                                                style: AppTextStyles.bodyMedium
                                                    .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                cartNotifier.updateQuantity(
                                                  product.id,
                                                  item.quantity + 1,
                                                );
                                              },
                                              child: const Padding(
                                                padding: EdgeInsets.all(4.0),
                                                child: Icon(
                                                  Icons.add,
                                                  size: 16,
                                                  color: AppColors.grey700,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),

                                      // Tombol Hapus Item
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          color: AppColors.accentRed,
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmDialog(
                                            context,
                                            product.id,
                                            product.name,
                                            cartNotifier,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Bottom Section Total & Checkout
                Container(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: const Border(
                      top: BorderSide(color: AppColors.grey200),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Pembayaran',
                              style: AppTextStyles.h4.copyWith(
                                color: AppColors.grey700,
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(
                                cartNotifier.totalPrice,
                              ),
                              style: AppTextStyles.h3.copyWith(
                                color: AppColors.primaryTeal,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => context.push('/shop/checkout'),
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
                            'Checkout (${cartNotifier.totalItems})',
                            style: AppTextStyles.button.copyWith(
                              color: AppColors.white,
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
  }

  Widget _buildEmptyState(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_cart_outlined,
      title: 'Keranjang Belanja Kosong',
      subtitle: 'Yuk belanja kebutuhan anabul kesayanganmu sekarang!',
      actionLabel: 'Mulai Belanja',
      onAction: () => context.go('/main/shop'),
    );
  }

  void _showDeleteConfirmDialog(
    BuildContext context,
    int productId,
    String productName,
    CartNotifier notifier,
  ) async {
    final confirmed = await DialogHelper.confirm(
      context,
      title: 'Hapus Produk',
      message: 'Yakin ingin menghapus "$productName" dari keranjang?',
      confirmLabel: 'Hapus',
      isDangerous: true,
    );

    if (confirmed) {
      notifier.removeItem(productId);
    }
  }
}
