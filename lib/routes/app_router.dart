import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/models/order_model.dart';

import '../features/activity/screens/activity_screen.dart';
import '../features/adoption/screens/adoption_detail_screen.dart';
import '../features/adoption/screens/adoption_list_screen.dart';
import '../features/articles/screens/article_detail_screen.dart';
import '../features/articles/screens/articles_list_screen.dart';
import '../features/auth/providers/auth_provider.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/booking/screens/booking_form_screen.dart';
import '../features/booking/screens/clinic_list_screen.dart';
import '../features/consultation/screens/chat_bot_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/main_nav/screens/main_nav_screen.dart';
import '../features/pets/providers/pets_provider.dart';
import '../features/pets/screens/pet_detail_screen.dart';
import '../features/pets/screens/pet_form_screen.dart';
import '../features/pets/screens/pets_list_screen.dart';
import '../features/profile/screens/about_screen.dart';
import '../features/profile/screens/edit_profile_screen.dart';
import '../features/profile/screens/help_screen.dart';
import '../features/profile/screens/privacy_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/shop/screens/cart_screen.dart';
import '../features/shop/screens/checkout_screen.dart';
import '../features/shop/screens/order_detail_screen.dart';
import '../features/shop/screens/product_detail_screen.dart';
import '../features/shop/screens/shop_screen.dart';
import '../features/splash/screens/splash_screen.dart';

/// Provider konfigurasi routing aplikasi menggunakan go_router dan terintegrasi dengan AuthNotifier.
final routerProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      // Jangan redirect jika sedang berada di splash screen
      if (state.matchedLocation == '/splash') {
        return null;
      }

      final isLoggedIn = auth.value?.isLoggedIn ?? false;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';

      // Jika belum login dan mengakses halaman yang butuh proteksi auth
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }

      // Jika sudah login dan mencoba mengakses halaman login/register
      if (isLoggedIn && isAuthRoute) {
        return '/main/home';
      }

      return null;
    },
    routes: [
      // Route Splash Screen
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      // Route Autentikasi

      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Redirect /main ke branch beranda default
      GoRoute(
        path: '/main',
        redirect: (context, state) => '/main/home',
      ),

      // Route Manajemen Anabul (Pet)
      GoRoute(
        path: '/pets',
        builder: (context, state) => const PetsListScreen(),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => PetFormScreen(
              isOnboarding: state.uri.queryParameters['isOnboarding'] == 'true',
            ),
          ),
          GoRoute(
            path: 'edit/:id',
            builder: (context, state) {
              final petId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              final pet = ref
                  .read(petsProvider)
                  .value
                  ?.where((p) => p.id == petId)
                  .firstOrNull;
              return PetFormScreen(existingPet: pet);
            },
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final petId = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return PetDetailScreen(petId: petId);
            },
            routes: [
              // Route Rekam Medis (sub-route dari /pets/:id)
              GoRoute(
                path: 'health-records',
                builder: (context, state) {
                  final petId =
                      int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  return PetDetailScreen(petId: petId);
                },
              ),
              // Route Pengingat (sub-route dari /pets/:id)
              GoRoute(
                path: 'reminders',
                builder: (context, state) {
                  final petId =
                      int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  return PetDetailScreen(petId: petId);
                },
              ),
            ],
          ),
        ],
      ),

      // Route Chat Bot PetBot
      GoRoute(
        path: '/consultation/chat-bot',
        builder: (context, state) => const ChatBotScreen(),
      ),

      // Route Booking Klinik PetCare
      GoRoute(
        path: '/booking/clinics',
        builder: (context, state) => ClinicListScreen(
          initialBookingType: state.uri.queryParameters['type'],
        ),
      ),
      GoRoute(
        path: '/booking/form/:id',
        builder: (context, state) {
          final clinicId = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          return BookingFormScreen(
            clinicId: clinicId,
            initialBookingType: state.uri.queryParameters['bookingType'],
          );
        },
      ),

      // Route Pet Shop (Detail Produk, Keranjang, Checkout)
      GoRoute(
        path: '/shop/product/:id',
        builder: (context, state) {
          final productId = int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          return ProductDetailScreen(productId: productId);
        },
      ),
      GoRoute(
        path: '/shop/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/shop/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),

      // Route Detail Pesanan (dari Aktivitas)
      GoRoute(
        path: '/activity/order/:id',
        builder: (context, state) {
          final order = state.extra as Order?;
          if (order == null) return const _NotFoundPage();
          return OrderDetailScreen(order: order);
        },
      ),

      // Route Profil Sub-pages
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/profile/help',
        builder: (context, state) => const HelpScreen(),
      ),
      GoRoute(
        path: '/profile/privacy',
        builder: (context, state) => const PrivacyScreen(),
      ),

      // Route Artikel (Pet Care Tips)
      GoRoute(
        path: '/articles',
        builder: (context, state) => const ArticlesListScreen(),
      ),
      GoRoute(
        path: '/articles/:id',
        builder: (context, state) {
          final articleId =
              int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          return ArticleDetailScreen(articleId: articleId);
        },
      ),

      // Route Adopsi Hewan
      GoRoute(
        path: '/adoption',
        builder: (context, state) => const AdoptionListScreen(),
      ),
      GoRoute(
        path: '/adoption/:id',
        builder: (context, state) {
          final adoptionId =
              int.tryParse(state.pathParameters['id'] ?? '') ?? 1;
          return AdoptionDetailScreen(adoptionId: adoptionId);
        },
      ),

      // Navigasi Utama dengan 4 Branch (StatefulShellRoute)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavScreen(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Beranda
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),

          // Branch 1: Shop
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/shop',
                builder: (context, state) => const ShopScreen(),
              ),
            ],
          ),

          // Branch 2: Aktivitas
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/activity',
                builder: (context, state) => const ActivityScreen(),
              ),
            ],
          ),

          // Branch 3: Profil
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/main/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

/// Halaman fallback jika route tidak ditemukan atau extra tidak valid.
class _NotFoundPage extends StatelessWidget {
  const _NotFoundPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Halaman tidak ditemukan')),
      body: const Center(child: Text('Data tidak tersedia')),
    );
  }
}
