import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';
import '../widgets/product_card.dart';

/// Halaman katalog belanja Pet Shop PetCare.
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartCountProvider);
    final activeFilter = ref.watch(productFilterProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppBackground.topColor,
      appBar: AppBar(
        title: Text(
          'Pet Shop',
          style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
        ),
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
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
      body: AppBackground(child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Section Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.md,
              AppSizes.screenPadding,
              0,
            ),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: AppColors.grey300),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  ref.read(productFilterProvider.notifier).setSearch(val);
                },
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.grey500,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.grey500,
                    size: 22,
                  ),
                  suffixIcon: activeFilter.search.isNotEmpty
                      ? IconButton(
                          icon: const Icon(
                            Icons.clear,
                            color: AppColors.grey500,
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(productFilterProvider.notifier)
                                .setSearch('');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.md,
                    vertical: AppSizes.md,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),

          // Section Filter Kategori Horizontal
          SizedBox(
            height: 42,
            child: categoriesAsync.when(
              loading: () => const SizedBox(),
              error: (_, _) => const SizedBox(),
              data: (categories) {
                final allOptions = ['Semua', ...categories];

                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSizes.screenPadding,
                  ),
                  itemCount: allOptions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(width: AppSizes.sm),
                  itemBuilder: (context, index) {
                    final cat = allOptions[index];
                    final isSelected = (cat == 'Semua' &&
                            activeFilter.category == null) ||
                        activeFilter.category == cat;

                    return ChoiceChip(
                      label: Text(
                        cat,
                        style: AppTextStyles.caption.copyWith(
                          color:
                              isSelected ? AppColors.white : AppColors.grey700,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.w500,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: AppColors.primaryTeal,
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.chip),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryTeal
                              : AppColors.grey300,
                        ),
                      ),
                      onSelected: (selected) {
                        if (selected) {
                          ref
                              .read(productFilterProvider.notifier)
                              .setCategory(cat == 'Semua' ? null : cat);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: AppSizes.sm),

          // Grid Produk
          Expanded(
            child: productsAsync.when(
              loading: () =>
                  const LoadingWidget(message: 'Memuat katalog produk...'),
              error: (err, _) => CustomErrorWidget(
                message: 'Gagal memuat produk: $err',
                onRetry: () => ref.invalidate(productsProvider),
              ),
              data: (products) {
                if (products.isEmpty) {
                  return const EmptyState(
                    icon: Icons.search_off_outlined,
                    title: 'Produk Tidak Ditemukan',
                    subtitle: 'Coba gunakan kata kunci atau kategori lain',
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    AppSizes.screenPadding,
                    AppSizes.sm,
                    AppSizes.screenPadding,
                    AppSizes.screenPadding + 70, // Ruang ekstra untuk nav bar
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppSizes.md,
                    crossAxisSpacing: AppSizes.md,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ProductCard(product: product);
                  },
                );
              },
            ),
          ),
        ],
      ),
      ),
    );
  }
}
