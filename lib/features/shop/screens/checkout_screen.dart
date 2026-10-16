import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../core/utils/dialog_helper.dart';
import '../../../core/utils/snackbar_helper.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';

/// Halaman penyelesaian pesanan dan pengisian data checkout Pet Shop.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String _selectedPayment = 'COD';

  @override
  void initState() {
    super.initState();
    // Isi otomatis data profil user yang tersimpan
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = ref.read(authProvider).value?.user;
      if (user != null) {
        _nameController.text = user.name;
        if (user.phone != null) _phoneController.text = user.phone!;
        if (user.address != null) _addressController.text = user.address!;
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _onCheckout() async {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final address = _addressController.text.trim();

    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      SnackbarHelper.warning(
        context,
        'Lengkapi nama, nomor telepon, dan alamat pengiriman',
      );
      return;
    }

    final user = ref.read(authProvider).value?.user;
    if (user == null) {
      SnackbarHelper.warning(context, 'Silakan login terlebih dahulu');
      return;
    }

    final cartItems = ref.read(cartProvider);
    if (cartItems.isEmpty) {
      SnackbarHelper.warning(context, 'Keranjang belanja kosong');
      return;
    }

    final fullAddress = '$name, $phone, $address ($_selectedPayment)';

    final order = await ref.read(createOrderProvider.notifier).create(
          userId: user.id,
          items: cartItems,
          shippingAddress: fullAddress,
        );

    if (order != null && mounted) {
      // Kosongkan keranjang belanja
      ref.read(cartProvider.notifier).clear();

      // Tampilkan dialog sukses
      await DialogHelper.showSuccess(
        context,
        title: 'Pesanan Berhasil Dibuat!',
        message:
            'Pesanan #${order.id} berhasil dicatat dan sedang diproses oleh tim PetCare.',
        buttonLabel: 'Lihat Pesanan',
        onClose: () => context.go('/main/activity'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final orderState = ref.watch(createOrderProvider);

    return Scaffold(
      backgroundColor: AppColors.grey50,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: AppTextStyles.h3.copyWith(color: AppColors.grey900),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.grey900),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Section Alamat Pengiriman
            Text(
              'Alamat Pengiriman',
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nama Penerima',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Nomor Telepon',
                      prefixIcon: Icon(Icons.phone_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: AppSizes.md),
                  TextFormField(
                    controller: _addressController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Alamat Lengkap',
                      prefixIcon: Icon(Icons.home_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Section Metode Pembayaran
            Text(
              'Metode Pembayaran',
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.grey300),
              ),
              child: RadioGroup<String>(
                groupValue: _selectedPayment,
                onChanged: (val) {
                  if (val != null) {
                    setState(() {
                      _selectedPayment = val;
                    });
                  }
                },
                child: const Column(
                  children: [
                    RadioListTile<String>(
                      title: Text('COD (Bayar di Tempat)'),
                      subtitle: Text('Bayar saat kurir mengantar barang'),
                      value: 'COD',
                      activeColor: AppColors.primaryTeal,
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      title: Text('Transfer Bank'),
                      subtitle: Text('BCA, Mandiri, BNI, BRI Virtual Account'),
                      value: 'Transfer Bank',
                      activeColor: AppColors.primaryTeal,
                    ),
                    Divider(height: 1),
                    RadioListTile<String>(
                      title: Text('E-Wallet'),
                      subtitle: Text('GoPay, OVO, DANA, ShopeePay'),
                      value: 'E-Wallet',
                      activeColor: AppColors.primaryTeal,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSizes.lg),

            // Section Ringkasan Pesanan
            Text(
              'Ringkasan Pesanan',
              style: AppTextStyles.h4.copyWith(color: AppColors.grey900),
            ),
            const SizedBox(height: AppSizes.sm),
            Container(
              padding: const EdgeInsets.all(AppSizes.cardPadding),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.grey300),
              ),
              child: Column(
                children: [
                  ...cartItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${item.product.name} x${item.quantity}',
                              style: AppTextStyles.body.copyWith(
                                color: AppColors.grey700,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            CurrencyFormatter.format(item.subtotal),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.grey900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.grey200),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Pembayaran',
                        style: AppTextStyles.h4.copyWith(
                          color: AppColors.grey900,
                        ),
                      ),
                      Text(
                        CurrencyFormatter.format(cartNotifier.totalPrice),
                        style: AppTextStyles.h3.copyWith(
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xxl),

            // Tombol Buat Pesanan
            ElevatedButton(
              onPressed: orderState.isLoading ? null : _onCheckout,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                foregroundColor: AppColors.white,
                minimumSize: const Size(double.infinity, 50),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.btn),
                ),
              ),
              child: orderState.isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: AppColors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Text(
                      'Buat Pesanan Sekarang',
                      style: AppTextStyles.button.copyWith(
                        color: AppColors.white,
                      ),
                    ),
            ),
            const SizedBox(height: AppSizes.lg),
          ],
        ),
      ),
    );
  }
}
