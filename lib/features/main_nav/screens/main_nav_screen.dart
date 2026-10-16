import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/providers/auth_provider.dart';
import '../widgets/curved_bottom_nav_bar.dart';

/// Screen shell utama untuk navigasi bottom bar 4 tab dengan gaya Curved Top Edge modern.
class MainNavScreen extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavScreen({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value?.user;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: CurvedBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        user: user,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
      ),
    );
  }
}
