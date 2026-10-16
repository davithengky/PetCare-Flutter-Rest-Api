import 'package:flutter/material.dart';

/// Tipografi dan gaya teks aplikasi PetCare sesuai dengan Design System.
class AppTextStyles {
  // Private constructor agar class ini tidak dapat diinstansiasi
  AppTextStyles._();

  static const String _fontFamily = 'Poppins';

  /// Display (28sp, Bold 700, Line Height 1.3) - Angka besar, hero
  static const TextStyle display = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// H1 (24sp, Bold 700, Line Height 1.3) - Judul halaman utama
  static const TextStyle h1 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 24.0,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  /// H2 (20sp, SemiBold 600, Line Height 1.3) - Judul section
  static const TextStyle h2 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 20.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// H3 (18sp, SemiBold 600, Line Height 1.3) - Judul card besar
  static const TextStyle h3 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 18.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// H4 (16sp, SemiBold 600, Line Height 1.4) - Judul card, item list
  static const TextStyle h4 = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  /// Body Large (16sp, Regular 400, Line Height 1.5) - Body utama
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body (14sp, Regular 400, Line Height 1.5) - Body default
  static const TextStyle body = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  /// Body Medium (14sp, Medium 500, Line Height 1.5) - Body emphasized
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    height: 1.5,
  );

  /// Body Small (12sp, Regular 400, Line Height 1.4) - Subtitle, hint
  static const TextStyle bodySmall = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  /// Caption (10sp, Regular 400, Line Height 1.3) - Label kecil, badge
  static const TextStyle caption = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10.0,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// Button (14sp, SemiBold 600, Line Height 1.2) - Text di tombol
  static const TextStyle button = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 14.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// Overline (10sp, SemiBold 600, Line Height 1.2, Letter Spacing 0.5) - Label kategori
  static const TextStyle overline = TextStyle(
    fontFamily: _fontFamily,
    fontSize: 10.0,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );
}
