import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/adoption_model.dart';
import '../providers/adoption_provider.dart';

/// Halaman daftar hewan adopsi dengan pencarian dan filter jenis hewan (spesies).
class AdoptionListScreen extends ConsumerStatefulWidget {
  const AdoptionListScreen({super.key});

  @override
  ConsumerState<AdoptionListScreen> createState() => _AdoptionListScreenState();
}

class _AdoptionListScreenState extends ConsumerState<AdoptionListScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> _speciesList = const [
    'Semua',
    'Kucing',
    'Anjing',
  ];

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentFilter = ref.watch(adoptionFilterProvider);
    final adoptionsAsync = ref.watch(adoptionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Adopsi Anabul'),
      ),
      body: Column(
        children: [
          // Search Input
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.screenPadding,
              AppSizes.sm,
              AppSizes.screenPadding,
              AppSizes.sm,
            ),
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari nama atau deskripsi hewan...',
                prefixIcon: const Icon(Icons.search, color: AppColors.grey500),
                suffixIcon: _searchCtrl.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          ref
                              .read(adoptionFilterProvider.notifier)
                              .setSearch('');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md,
                  vertical: AppSizes.sm,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  borderSide: const BorderSide(color: AppColors.grey300),
                ),
              ),
              onChanged: (val) {
                ref.read(adoptionFilterProvider.notifier).setSearch(val);
              },
            ),
          ),

          // Species Chips
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.screenPadding,
                vertical: 6,
              ),
              itemCount: _speciesList.length,
              separatorBuilder: (context, index) => const SizedBox(width: AppSizes.sm),
              itemBuilder: (context, index) {
                final species = _speciesList[index];
                final isSelected = currentFilter.species == species;

                return ChoiceChip(
                  label: Text(species),
                  selected: isSelected,
                  selectedColor: AppColors.primaryTeal,
                  backgroundColor: AppColors.white,
                  labelStyle: AppTextStyles.bodySmall.copyWith(
                    color: isSelected ? AppColors.white : AppColors.grey700,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primaryTeal
                        : AppColors.grey300,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.chip),
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      ref
                          .read(adoptionFilterProvider.notifier)
                          .setSpecies(species);
                    }
                  },
                );
              },
            ),
          ),

          const SizedBox(height: AppSizes.sm),

          // Adoptions List
          Expanded(
            child: adoptionsAsync.when(
              loading: () =>
                  const LoadingWidget(message: 'Memuat data adopsi...'),
              error: (e, _) => CustomErrorWidget(
                message: 'Gagal memuat adopsi: $e',
                onRetry: () => ref.refresh(adoptionsProvider),
              ),
              data: (adoptions) {
                if (adoptions.isEmpty) {
                  return const EmptyState(
                    icon: Icons.pets_outlined,
                    title: 'Belum Ada Hewan Adopsi',
                    subtitle: 'Coba cari dengan kata kunci lain.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.screenPadding),
                  itemCount: adoptions.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.md),
                  itemBuilder: (context, index) {
                    final item = adoptions[index];
                    return _buildAdoptionCard(context, item);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdoptionCard(BuildContext context, Adoption item) {
    final isCat = item.species.toLowerCase() == 'kucing';

    return InkWell(
      onTap: () => context.push('/adoption/${item.id}'),
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSizes.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.grey300),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppImage(
              url: item.photoUrl,
              width: 70,
              height: 70,
              fallbackIcon: isCat ? Icons.pets : Icons.pets_outlined,
              fallbackColor:
                  isCat ? AppColors.accentOrange : AppColors.accentBlue,
              backgroundColor: isCat
                  ? AppColors.accentOrange.withValues(alpha: 0.15)
                  : AppColors.accentBlue.withValues(alpha: 0.15),
              fallbackIconSize: 34,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            const SizedBox(width: AppSizes.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.name,
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.grey900,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryTeal.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppRadius.chip),
                        ),
                        child: Text(
                          item.species,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primaryTeal,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Usia: ${item.age}',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.grey500,
                    ),
                  ),
                  const SizedBox(height: AppSizes.xs),
                  Text(
                    item.description,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.grey700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
