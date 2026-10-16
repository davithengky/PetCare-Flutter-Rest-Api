import 'package:flutter/material.dart';

/// Background gradient hijau→biru yang dipakai konsisten di seluruh tab utama.
///
/// Gradient ini sama persis dengan background halaman Home.
class AppBackground extends StatelessWidget {
  /// Warna paling atas gradient (dipasang di Home).
  static const Color topColor = Color(0xFFA8E6CF);

  /// Warna paling bawah gradient (dipasang di Home).
  static const Color bottomColor = Color(0xFFB3E5FC);

  final Widget child;

  const AppBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [topColor, bottomColor],
        ),
      ),
      child: child,
    );
  }
}
