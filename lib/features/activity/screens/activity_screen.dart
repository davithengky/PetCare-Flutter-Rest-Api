import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/widgets/app_background.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_widget.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../data/models/booking_model.dart';
import '../../../data/models/order_model.dart';
import '../providers/activity_provider.dart';

/// Halaman Aktivitas — menampilkan riwayat booking, order, dan konsultasi
/// dengan filter berdasarkan tipe dan status.
class ActivityScreen extends ConsumerStatefulWidget {
  const ActivityScreen({super.key});

  @override
  ConsumerState<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends ConsumerState<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const _typeTabs = [
    _TypeTab(label: 'Semua', value: 'all'),
    _TypeTab(label: 'Booking', value: 'booking'),
    _TypeTab(label: 'Pesanan', value: 'order'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _typeTabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) return;
      final value = _typeTabs[_tabController.index].value;
      ref.read(activityFilterProvider.notifier).setTypeFilter(value);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activityAsync = ref.watch(activityProvider);
    final filter = ref.watch(activityFilterProvider);

    return Scaffold(
      backgroundColor: AppBackground.topColor,
      body: AppBackground(child: NestedScrollView(
        headerSliverBuilder: (context, _) => [
          _buildSliverAppBar(filter),
        ],
        body: activityAsync.when(
          loading: () =>
              const LoadingWidget(message: 'Memuat data aktivitas...'),
          error: (e, _) => CustomErrorWidget(
            message: e.toString(),
            onRetry: () => ref.refresh(activityProvider),
          ),
          data: (items) => items.isEmpty
              ? _buildEmpty()
              : ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.lg),
                  itemCount: items.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.md),
                  itemBuilder: (context, index) =>
                      _ActivityCard(item: items[index]),
                ),
        ),
      ),
      ),
    );
  }

  Widget _buildSliverAppBar(ActivityFilter filter) {
    const statusBarHeight = 38.0;

    // TabBar disimpan sebagai variabel agar tinggi aslinya bisa dibaca.
    // Tinggi TabBar = 46 (tinggi tab) + indicatorWeight.
    final tabBar = TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
      indicatorColor: AppColors.accentYellow,
      indicatorWeight: 3,
      labelColor: AppColors.white,
      unselectedLabelColor: AppColors.white.withValues(alpha: 0.6),
      labelStyle: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.poppins(fontSize: 13),
      tabs: _typeTabs.map((t) => Tab(text: t.label)).toList(),
    );

    return SliverAppBar(
      pinned: true,
      floating: true,
      expandedHeight: 192,
      backgroundColor: AppColors.primaryTeal,
      elevation: 0,
      automaticallyImplyLeading: false,
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
              AppSizes.lg, AppSizes.xxxl + AppSizes.md, AppSizes.lg, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Aktivitas',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
              Text(
                'Riwayat booking & pesanan kamu',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: AppColors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        // Tinggi = chip status (38) + tinggi asli TabBar (46 + indicatorWeight).
        preferredSize: Size.fromHeight(
          statusBarHeight + tabBar.preferredSize.height,
        ),
        // Sengaja tanpa warna background agar gradient flexibleSpace di
        // belakangnya menyambung tanpa garis warna (seam).
        child: Column(
          children: [
            _buildStatusFilterBar(filter),
            tabBar,
          ],
        ),
      ),
    );
  }

  Widget _buildStatusFilterBar(ActivityFilter filter) {
    const statuses = [
      _StatusChip(label: 'Semua', value: 'all'),
      _StatusChip(label: 'Pending', value: 'pending'),
      _StatusChip(label: 'Selesai', value: 'selesai'),
      _StatusChip(label: 'Dibatalkan', value: 'dibatalkan'),
    ];

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
        itemCount: statuses.length,
        separatorBuilder: (context, index) =>
            const SizedBox(width: AppSizes.sm),
        itemBuilder: (context, index) {
          final chip = statuses[index];
          final isSelected = filter.statusFilter == chip.value;
          return GestureDetector(
            onTap: () => ref
                .read(activityFilterProvider.notifier)
                .setStatusFilter(chip.value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.md, vertical: AppSizes.xs + 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.accentYellow
                    : AppColors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSizes.sm),
                border: Border.all(
                  color: isSelected
                      ? AppColors.accentYellow
                      : AppColors.white.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                chip.label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.grey900 : AppColors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmpty() {
    return const EmptyState(
      icon: Icons.inbox_outlined,
      title: 'Belum Ada Aktivitas',
      subtitle: 'Aktivitas booking dan pesananmu akan muncul di sini',
    );
  }
}

// ─────────────────────────────────────────────
// Widget Kartu Aktivitas
// ─────────────────────────────────────────────

class _ActivityCard extends ConsumerWidget {
  final ActivityItem item;

  const _ActivityCard({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => _onTap(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSizes.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withValues(alpha: 0.5),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, color: AppColors.grey200),
            _buildBody(),
          ],
        ),
      ),
    );
  }

  void _onTap(BuildContext context) {
    if (item.type == ActivityType.order) {
      final order = item.payload as Order;
      context.push('/activity/order/${order.id}', extra: order);
    }
  }

  Widget _buildHeader() {
    final config = _typeConfig(item.type);
    final status = _getStatus();
    final statusCfg = _statusConfig(status);

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.lg, AppSizes.md, AppSizes.md, AppSizes.md),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: config.bgColor,
              borderRadius: BorderRadius.circular(AppSizes.sm),
            ),
            child: Icon(config.icon, color: config.iconColor, size: 18),
          ),
          const SizedBox(width: AppSizes.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  config.label,
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.grey900,
                  ),
                ),
                Text(
                  _formatDate(item.date),
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    color: AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.sm + 2, vertical: AppSizes.xs),
            decoration: BoxDecoration(
              color: statusCfg.bgColor,
              borderRadius: BorderRadius.circular(AppSizes.xs + 2),
            ),
            child: Text(
              statusCfg.label,
              style: GoogleFonts.poppins(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: statusCfg.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          AppSizes.lg, AppSizes.sm, AppSizes.lg, AppSizes.md),
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (item.type == ActivityType.booking) {
      final b = item.payload as Booking;
      return _InfoRow(rows: [
        _InfoEntry(label: 'Layanan', value: _formatBookingType(b.bookingType)),
        _InfoEntry(label: 'Jadwal', value: _formatDate(b.scheduleDate)),
        if (b.notes != null && b.notes!.isNotEmpty)
          _InfoEntry(label: 'Catatan', value: b.notes!),
      ]);
    } else {
      final o = item.payload as Order;
      final fmt = NumberFormat.currency(
          locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
      final preview = o.items.take(2).map((i) => i.productName).join(', ');
      final suffix = o.items.length > 2 ? '...' : '';
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(rows: [
            _InfoEntry(
                label: 'Produk',
                value: '${o.items.length} item — $preview$suffix'),
            _InfoEntry(label: 'Total', value: fmt.format(o.totalAmount)),
          ]),
          const SizedBox(height: AppSizes.sm),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'Lihat Detail →',
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryTeal,
              ),
            ),
          ),
        ],
      );
    }
  }

  String _getStatus() {
    if (item.payload is Booking) return (item.payload as Booking).status;
    if (item.payload is Order) return (item.payload as Order).status;
    return '';
  }

  String _formatDate(DateTime dt) =>
      DateFormat('dd MMM yyyy, HH:mm', 'id_ID').format(dt);

  String _formatBookingType(String type) {
    switch (type) {
      case 'consultation':
        return 'Konsultasi';
      case 'grooming':
        return 'Grooming';
      case 'vaccination':
        return 'Vaksinasi';
      default:
        return type;
    }
  }

  _TypeConfig _typeConfig(ActivityType type) {
    switch (type) {
      case ActivityType.booking:
        return const _TypeConfig(
          label: 'Booking Klinik',
          icon: Icons.calendar_month_rounded,
          bgColor: AppColors.primaryLight,
          iconColor: AppColors.primaryTeal,
        );
      case ActivityType.order:
        return const _TypeConfig(
          label: 'Pesanan Shop',
          icon: Icons.shopping_bag_rounded,
          bgColor: Color(0xFFFFF3E0),
          iconColor: AppColors.accentOrange,
        );
    }
  }

  _StatusConfig _statusConfig(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'waiting_payment':
        return const _StatusConfig(
          label: 'Menunggu',
          bgColor: AppColors.warningBg,
          textColor: AppColors.warningText,
        );
      case 'confirmed':
      case 'processing':
        return const _StatusConfig(
          label: 'Diproses',
          bgColor: AppColors.infoBg,
          textColor: AppColors.infoText,
        );
      case 'shipped':
        return const _StatusConfig(
          label: 'Dikirim',
          bgColor: Color(0xFFE8EAF6),
          textColor: Color(0xFF283593),
        );
      case 'delivered':
      case 'completed':
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
      case 'active':
        return const _StatusConfig(
          label: 'Aktif',
          bgColor: AppColors.primaryLight,
          textColor: AppColors.primaryDark,
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
// Helper Widgets & Data Classes
// ─────────────────────────────────────────────

class _InfoRow extends StatelessWidget {
  final List<_InfoEntry> rows;
  const _InfoRow({required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: rows
          .map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 72,
                    child: Text(
                      e.label,
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.grey500),
                    ),
                  ),
                  Text(': ',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.grey500)),
                  Expanded(
                    child: Text(
                      e.value,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}

class _InfoEntry {
  final String label;
  final String value;
  const _InfoEntry({required this.label, required this.value});
}

class _TypeConfig {
  final String label;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  const _TypeConfig({
    required this.label,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
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

class _TypeTab {
  final String label;
  final String value;
  const _TypeTab({required this.label, required this.value});
}

class _StatusChip {
  final String label;
  final String value;
  const _StatusChip({required this.label, required this.value});
}
