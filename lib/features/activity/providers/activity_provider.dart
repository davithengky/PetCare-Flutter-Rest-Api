import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/booking_model.dart';
import '../../../data/models/order_model.dart';
import '../../auth/providers/auth_provider.dart';
import '../../booking/providers/booking_provider.dart';
import '../../shop/providers/orders_provider.dart';

/// Jenis tipe aktivitas transaksi pengguna di aplikasi PetCare.
enum ActivityType { booking, order }

/// Item gabungan aktivitas transaksi (Booking klinik atau Pesanan produk).
class ActivityItem {
  final ActivityType type;
  final DateTime date;
  final dynamic payload; // Booking | Order | Consultation

  const ActivityItem({
    required this.type,
    required this.date,
    required this.payload,
  });
}

/// State filter aktivitas berdasarkan tipe dan status.
class ActivityFilter {
  final String? statusFilter; // 'all' | 'pending' | 'completed' | dst
  final String? typeFilter; // 'all' | 'booking' | 'order'

  const ActivityFilter({
    this.statusFilter = 'all',
    this.typeFilter = 'all',
  });

  ActivityFilter copyWith({
    String? statusFilter,
    String? typeFilter,
  }) {
    return ActivityFilter(
      statusFilter: statusFilter ?? this.statusFilter,
      typeFilter: typeFilter ?? this.typeFilter,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ActivityFilter &&
        other.statusFilter == statusFilter &&
        other.typeFilter == typeFilter;
  }

  @override
  int get hashCode => Object.hash(statusFilter, typeFilter);
}

/// Notifier pengelola state filter aktivitas.
class ActivityFilterNotifier extends Notifier<ActivityFilter> {
  @override
  ActivityFilter build() =>
      const ActivityFilter(statusFilter: 'all', typeFilter: 'all');

  void setStatusFilter(String? status) {
    state = state.copyWith(statusFilter: status);
  }

  void setTypeFilter(String? type) {
    state = state.copyWith(typeFilter: type);
  }

  void reset() {
    state = const ActivityFilter(statusFilter: 'all', typeFilter: 'all');
  }
}

/// Provider state filter aktivitas.
final activityFilterProvider =
    NotifierProvider<ActivityFilterNotifier, ActivityFilter>(
  ActivityFilterNotifier.new,
);

/// Provider gabungan seluruh aktivitas pengguna (Booking & Order) dengan filter dan sorting.
final activityProvider = FutureProvider<List<ActivityItem>>((ref) async {
  final userId = ref.watch(authProvider).value?.user?.id;
  if (userId == null) return [];

  final filter = ref.watch(activityFilterProvider);
  final bookings = await ref.watch(bookingRepoProvider).getUserBookings(userId);
  final orders = await ref.watch(orderRepoProvider).getUserOrders(userId);

  final items = <ActivityItem>[
    ...bookings.map(
      (b) => ActivityItem(
        type: ActivityType.booking,
        date: b.scheduleDate,
        payload: b,
      ),
    ),
    ...orders.map(
      (o) => ActivityItem(
        type: ActivityType.order,
        date: o.createdAt,
        payload: o,
      ),
    ),
  ];

  var filtered = items;

  // Filter berdasarkan tipe aktivitas
  if (filter.typeFilter != null &&
      filter.typeFilter != 'all' &&
      filter.typeFilter!.isNotEmpty) {
    filtered =
        filtered.where((i) => i.type.name == filter.typeFilter).toList();
  }

  // Filter berdasarkan status
  if (filter.statusFilter != null &&
      filter.statusFilter != 'all' &&
      filter.statusFilter!.isNotEmpty) {
    final targetStatus = filter.statusFilter!.toLowerCase();
    filtered = filtered.where((i) {
      final status = _getStatus(i).toLowerCase();
      // Penyesuaian pemetaan status umum
      if (targetStatus == 'pending') {
        return status == 'pending' ||
            status == 'waiting_payment' ||
            status == 'active';
      } else if (targetStatus == 'selesai' || targetStatus == 'completed') {
        return status == 'completed' ||
            status == 'delivered' ||
            status == 'confirmed';
      } else if (targetStatus == 'dibatalkan' || targetStatus == 'cancelled') {
        return status == 'cancelled';
      }
      return status == targetStatus;
    }).toList();
  }

  // Urutkan dari tanggal terbaru
  filtered.sort((a, b) => b.date.compareTo(a.date));
  return filtered;
});

/// Mendapatkan status dari payload aktivitas.
String _getStatus(ActivityItem item) {
  if (item.payload is Booking) {
    return (item.payload as Booking).status;
  } else if (item.payload is Order) {
    return (item.payload as Order).status;
  }
  return '';
}
