import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/widgets/app_image.dart';
import '../../../data/models/product_model.dart';

/// Kartu tampilan produk di dalam grid Pet Shop.
class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadius.card),
          onTap: () => context.push('/shop/product/${product.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Foto Produk & Badge Diskon
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppImage(
                      url: product.imageUrl,
                      fallbackIcon: Icons.pets,
                      fallbackIconSize: 46,
                      fit: BoxFit.cover,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(AppRadius.card),
                        topRight: Radius.circular(AppRadius.card),
                      ),
                    ),
                    if (product.isDiscounted)
                      Positioned(
                        top: AppSizes.sm,
                        right: AppSizes.sm,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.xs + 2,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentRed,
                            borderRadius: BorderRadius.circular(AppRadius.chip),
                          ),
                          child: Text(
                            '-${product.discountPercent.toStringAsFixed(0)}%',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Detail Informasi Produk
              Padding(
                padding: const EdgeInsets.all(AppSizes.sm + 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: AppTextStyles.overline.copyWith(
                        color: AppColors.accentOrange,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey900,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    // Harga & Diskon
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 4,
                      children: [
                        Text(
                          CurrencyFormatter.format(product.price),
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (product.isDiscounted &&
                            product.originalPrice != null)
                          Text(
                            CurrencyFormatter.format(product.originalPrice!),
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.grey500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Rating & Terjual
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 13,
                          color: AppColors.accentYellow,
                        ),
                        Text(
                          ' ${product.rating.toStringAsFixed(1)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          ' • ${product.soldCount} terjual',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.grey500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
