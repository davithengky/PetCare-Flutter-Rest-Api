import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/user_model.dart';

/// Widget navigasi bar bawah bergaya floating pill capsule.
///
/// Kartu putih mengambang dengan sudut membulat dan shadow lembut, di mana
/// tab aktif ditandai blok highlight biru muda di belakang ikonnya, ikon/label
/// aktif berwarna biru, sedangkan tab lain berwarna abu-abu. Label keempat tab
/// selalu tampil. Profil memakai avatar (lingkaran teal dengan inisial).
class CurvedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final User? user;

  const CurvedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 12.0),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(32.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 20.0,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
            child: Row(
              children: [
                // Tab 0: Home
                _buildNavItem(
                  index: 0,
                  label: 'Home',
                  iconBuilder: (isSelected) =>
                      _HomeHouseIcon(isSelected: isSelected),
                ),

                // Tab 1: Shop
                _buildNavItem(
                  index: 1,
                  label: 'Shop',
                  iconBuilder: (isSelected) => Icon(
                    isSelected
                        ? Icons.shopping_bag_rounded
                        : Icons.shopping_bag_outlined,
                    size: 23.0,
                    color: isSelected ? AppColors.navActive : AppColors.grey500,
                  ),
                ),

                // Tab 2: Aktivitas
                _buildNavItem(
                  index: 2,
                  label: 'Aktivitas',
                  iconBuilder: (isSelected) => Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Icon(
                        isSelected
                            ? Icons.receipt_long_rounded
                            : Icons.receipt_long_outlined,
                        size: 23.0,
                        color:
                            isSelected ? AppColors.navActive : AppColors.grey500,
                      ),
                      Positioned(
                        top: -1.0,
                        right: -3.0,
                        child: Container(
                          width: 6.0,
                          height: 6.0,
                          decoration: const BoxDecoration(
                            color: AppColors.accentRed,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tab 3: Profile (avatar dengan inisial)
                _buildNavItem(
                  index: 3,
                  label: 'Profile',
                  iconBuilder: (isSelected) => _ProfileAvatarIcon(
                    user: user,
                    isSelected: isSelected,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required Widget Function(bool isSelected) iconBuilder,
  }) {
    final isSelected = index == currentIndex;

    return Expanded(
      child: InkWell(
        onTap: () {
          if (!isSelected) {
            HapticFeedback.selectionClick();
            onTap(index);
          }
        },
        borderRadius: BorderRadius.circular(20.0),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Blok highlight di belakang ikon (biru muda saat aktif).
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 56.0,
                height: 34.0,
                decoration: BoxDecoration(
                  color:
                      isSelected ? AppColors.navActiveBg : Colors.transparent,
                  borderRadius: BorderRadius.circular(17.0),
                ),
                child: Center(child: iconBuilder(isSelected)),
              ),
              const SizedBox(height: 3.0),
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 11.0,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.navActive : AppColors.grey500,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom icon rumah dengan bentuk silhouette rounded dan pintu kecil di tengah saat aktif.
///
/// Warna mengikuti tema navigasi: biru saat aktif, abu-abu saat inaktif. Celah
/// pintu memakai warna highlight agar menyatu dengan latar blok aktif.
class _HomeHouseIcon extends StatelessWidget {
  final bool isSelected;

  const _HomeHouseIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(22, 23),
      painter: _HomeHousePainter(
        isSelected: isSelected,
        color: isSelected ? AppColors.navActive : AppColors.grey500,
        doorColor: AppColors.navActiveBg,
      ),
    );
  }
}

class _HomeHousePainter extends CustomPainter {
  final bool isSelected;
  final Color color;
  final Color doorColor;

  _HomeHousePainter({
    required this.isSelected,
    required this.color,
    required this.doorColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final paint = Paint()
      ..color = color
      ..style = isSelected ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    const double radius = 3.5;

    // Mulai dari atap atas tengah dengan sudut melengkung halus
    path.moveTo(w * 0.5, 1.5);

    // Sisi miring kiri ke teras kiri
    path.lineTo(2.2, h * 0.42);
    path.quadraticBezierTo(1.0, h * 0.46, 1.0, h * 0.52);

    // Dinding kiri lurus ke bawah
    path.lineTo(1.0, h - radius);
    path.quadraticBezierTo(1.0, h, 1.0 + radius, h);

    // Garis dasar bawah
    path.lineTo(w - 1.0 - radius, h);
    path.quadraticBezierTo(w - 1.0, h, w - 1.0, h - radius);

    // Dinding kanan lurus ke atas
    path.lineTo(w - 1.0, h * 0.52);
    path.quadraticBezierTo(w - 1.0, h * 0.46, w - 2.2, h * 0.42);

    // Sisi miring kanan kembali ke atap
    path.close();

    canvas.drawPath(path, paint);

    // Jika aktif, gambar celah pintu di tengah bawah
    if (isSelected) {
      final doorPaint = Paint()
        ..color = doorColor
        ..style = PaintingStyle.fill;

      final doorRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset(w * 0.5, h - 5.5),
          width: 2.8,
          height: 6.0,
        ),
        const Radius.circular(1.4),
      );
      canvas.drawRRect(doorRect, doorPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _HomeHousePainter oldDelegate) {
    return oldDelegate.isSelected != isSelected ||
        oldDelegate.color != color ||
        oldDelegate.doorColor != doorColor;
  }
}

/// Avatar profil yang disesuaikan dengan avatar di halaman profil
/// (lingkaran primaryTeal dengan inisial putih).
class _ProfileAvatarIcon extends StatelessWidget {
  final User? user;
  final bool isSelected;

  const _ProfileAvatarIcon({
    this.user,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final initial = (user?.name.isNotEmpty ?? false)
        ? user!.name.substring(0, 1).toUpperCase()
        : 'U';

    return Container(
      width: 27.0,
      height: 27.0,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? AppColors.primaryTeal
              : AppColors.primaryTeal.withValues(alpha: 0.35),
          width: isSelected ? 2.0 : 1.5,
        ),
      ),
      padding: const EdgeInsets.all(1.5),
      child: CircleAvatar(
        radius: 11.0,
        backgroundColor: AppColors.primaryTeal,
        backgroundImage: (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
            ? NetworkImage(user!.photoUrl!)
            : null,
        child: (user?.photoUrl != null && user!.photoUrl!.isNotEmpty)
            ? null
            : Text(
                initial,
                style: const TextStyle(
                  fontSize: 11.0,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }
}
