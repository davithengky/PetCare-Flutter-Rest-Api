import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Widget gambar jaringan dengan dukungan loading & fallback ikon.
///
/// Dipakai di seluruh aplikasi agar ketika URL gambar kosong/gagal dimuat,
/// tampilan tetap rapi dengan ikon placeholder (bukan gambar rusak).
class AppImage extends StatelessWidget {
  /// URL gambar. Bila null/kosong, langsung menampilkan ikon fallback.
  final String? url;

  /// Ikon yang dipakai sebagai placeholder / saat gambar gagal dimuat.
  final IconData fallbackIcon;

  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  /// Warna latar placeholder.
  final Color backgroundColor;

  /// Warna ikon fallback.
  final Color fallbackColor;

  final double fallbackIconSize;

  const AppImage({
    super.key,
    required this.url,
    this.fallbackIcon = Icons.pets,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.backgroundColor = AppColors.grey100,
    this.fallbackColor = AppColors.grey500,
    this.fallbackIconSize = 28,
  });

  bool get _hasUrl => url != null && url!.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: SizedBox(
        width: width,
        height: height,
        child: _hasUrl
            ? Image.network(
                url!,
                fit: fit,
                width: width,
                height: height,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return _placeholder(
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _placeholder(Widget child) {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: child,
    );
  }

  Widget _fallback() {
    return Container(
      color: backgroundColor,
      alignment: Alignment.center,
      child: Icon(fallbackIcon, color: fallbackColor, size: fallbackIconSize),
    );
  }
}
