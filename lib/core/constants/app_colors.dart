import 'package:flutter/material.dart';

/// Palet warna aplikasi PetCare sesuai dengan Design System.
class AppColors {
  // Private constructor agar class ini tidak dapat diinstansiasi
  AppColors._();

  // 1. Primary
  static const Color primaryTeal = Color(0xFF1B9AAA);
  static const Color primaryDark = Color(0xFF0F6E7C);
  static const Color primaryLight = Color(0xFFE0F2F4);

  // 2. Accent
  static const Color accentYellow = Color(0xFFF9C846);
  static const Color accentOrange = Color(0xFFFF8C42);
  static const Color accentPink = Color(0xFFE91E63);
  static const Color accentPurple = Color(0xFF9C27B0);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentBlue = Color(0xFF2196F3);
  static const Color accentRed = Color(0xFFE53935);

  // 3. Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey900 = Color(0xFF212121);

  // 4. Semantic
  static const Color successBg = Color(0xFFE8F5E9);
  static const Color successText = Color(0xFF2E7D32);
  static const Color infoBg = Color(0xFFE3F2FD);
  static const Color infoText = Color(0xFF1565C0);
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color warningText = Color(0xFFE65100);
  static const Color errorBg = Color(0xFFFFEBEE);
  static const Color errorText = Color(0xFFC62828);

  // 5. Navigation (Bottom Nav Bar floating pill)
  static const Color navActive = Color(0xFF1877D2);
  static const Color navActiveBg = Color(0xFFD6EBFF);
}
