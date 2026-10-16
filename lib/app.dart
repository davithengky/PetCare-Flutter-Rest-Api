import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/constants/app_colors.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

/// Root widget aplikasi PetCare yang mengamati perubahan routing berbasis Riverpod.
class PetCareApp extends ConsumerWidget {
  const PetCareApp({super.key});

  /// Lebar maksimum area aplikasi saat dijalankan di web (tampilan ala mobile).
  static const double _mobileWidth = 430;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'PetCare',
      theme: AppTheme.light,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        final content = child ?? const SizedBox.shrink();
        // Di web desktop, batasi lebar agar tampil seperti aplikasi mobile.
        if (!kIsWeb) return content;
        return ColoredBox(
          color: AppColors.grey200,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: _mobileWidth),
              child: content,
            ),
          ),
        );
      },
    );
  }
}
