# PRODUCT REQUIREMENTS DOCUMENT (PRD)
# PetCare — Flutter Mobile Application

| Informasi | Detail |
|---|---|
| Nama Proyek | PetCare |
| Dokumen | `01_PRD_Flutter.md` |
| Platform | Mobile Application (Android/iOS) |
| Konteks | Proyek Mata Kuliah Pemrograman Mobile |
| Versi Dokumen | 3.0 (Flutter Only) |
| Bagian | FRONTEND (Flutter) |
| Frontend | Flutter + Riverpod + go_router |
| Design Tool | Google Stitch |

---

## DAFTAR ISI

1. [Ringkasan Eksekutif](#1-ringkasan-eksekutif)
2. [Tujuan & Sasaran Pengguna](#2-tujuan--sasaran-pengguna)
3. [Ruang Lingkup](#3-ruang-lingkup)
4. [Onboarding Strategy — Hybrid](#4-onboarding-strategy--hybrid)
5. [Alur Pengguna Utama](#5-alur-pengguna-utama)
6. [Arsitektur Frontend](#6-arsitektur-frontend)
7. [Struktur Folder Flutter](#7-struktur-folder-flutter)
8. [State Management dengan Riverpod](#8-state-management-dengan-riverpod)
9. [Routing dengan go_router](#9-routing-dengan-go_router)
10. [Data Layer & Mock Repository](#10-data-layer--mock-repository)
11. [Realtime Chat (Mock Stream)](#11-realtime-chat-mock-stream)
12. [Local Storage](#12-local-storage)
13. [Push Notification Lokal](#13-push-notification-lokal)
14. [Error Handling & Loading State](#14-error-handling--loading-state)
15. [Tech Stack](#15-tech-stack)
16. [Dependencies](#16-dependencies)
17. [Environment & Config](#17-environment--config)
18. [Non-Functional Requirements](#18-non-functional-requirements)
19. [Design System Summary](#19-design-system-summary)
20. [Sprint Plan](#20-sprint-plan)
21. [Risiko & Mitigasi](#21-risiko--mitigasi)
22. [Metrik Keberhasilan](#22-metrik-keberhasilan)
23. [Referensi](#23-referensi)
24. [Checklist Setup (Sprint 0)](#checklist-setup-sprint-0)

---

## 1. RINGKASAN EKSEKUTIF

PetCare adalah aplikasi mobile all-in-one untuk pemilik hewan peliharaan. Dokumen ini khusus membahas aplikasi Flutter, mulai dari struktur folder, state management, routing, data layer, sampai penanganan notifikasi lokal.

Aplikasi ini dibangun secara mandiri (*standalone*) dengan data mock/dummy yang disimpan di repository lokal sehingga dapat dijalankan tanpa backend. Pendekatan ini memudahkan demo, pengujian UI, dan pengembangan paralel dengan backend di masa depan.

### Fokus Pengembangan

- UI/UX konsisten dengan Design System (`04_DESIGN_SYSTEM.md`).
- State management yang terstruktur menggunakan Riverpod.
- Routing terstruktur menggunakan go_router, termasuk authentication guard.
- Data layer menggunakan Mock Repository yang mudah diganti dengan API.
- Chat realtime disimulasikan melalui Stream di dalam aplikasi.
- Local persistence menggunakan `shared_preferences` dan `flutter_secure_storage`.
- Notifikasi lokal untuk pengingat vaksin dan obat.

---

## 2. TUJUAN & SASARAN PENGGUNA

### 2.1 Tujuan Proyek

1. Membangun UI mobile yang konsisten, responsif, dan ramah pengguna.
2. Menerapkan navigasi antarhalaman menggunakan go_router.
3. Mengelola state aplikasi menggunakan Riverpod.
4. Menyediakan data layer yang dapat diganti dari mock ke API tanpa mengubah UI.
5. Menampilkan data realtime berupa chat melalui Stream.
6. Menghasilkan APK fungsional sebagai deliverable akhir.

### 2.2 Target Pengguna

Pemilik hewan peliharaan yang membutuhkan akses terpusat untuk konsultasi, booking, belanja, dan manajemen rekam medis hewan.

### 2.3 User Persona Utama

| Persona | Deskripsi | Kebutuhan Utama |
|---|---|---|
| Budi (28) | Karyawan, memiliki 1 kucing | Konsultasi cepat dan pengingat vaksin |
| Sari (35) | Ibu rumah tangga, memiliki 3 anabul | Multi-pet management dan grooming rutin |
| Andi (22) | Mahasiswa, memiliki 1 anjing | Belanja hemat dan artikel edukasi |

---

## 3. RUANG LINGKUP

Aplikasi Flutter bertanggung jawab atas 14 fitur berikut.

| Kategori | Fitur | Deskripsi UI |
|---|---|---|
| Autentikasi & Akun | 1. Profil & Akun Pengguna | Login/register form, penyimpanan sesi, dan halaman profil |
| Manajemen Hewan | 2. Profil Hewan | Form tambah/edit pet dan upload foto dari galeri |
| Manajemen Hewan | 3. Catatan Kesehatan | Daftar dan form rekam medis secara in-memory |
| Manajemen Hewan | 4. Pengingat Vaksin & Obat | Form pengingat dan notifikasi lokal |
| Layanan Kesehatan | 5. Konsultasi Dokter Hewan | Chat UI menggunakan mock stream |
| Layanan Kesehatan | 6. Pencarian Dokter | Daftar dokter, filter, dan pencarian |
| Layanan Kesehatan | 7. Booking Klinik | Form booking dan kalender |
| Perawatan & Kebutuhan | 8. Grooming Booking | Form booking grooming |
| Perawatan & Kebutuhan | 9. Toko Pet (Pet Shop) | Grid produk dan halaman detail |
| Perawatan & Kebutuhan | 10. Keranjang & Checkout | Keranjang lokal dan form checkout |
| Eksplorasi & Edukasi | 11. Beranda PetCare (Home) | Dashboard, banner, dan shortcut |
| Eksplorasi & Edukasi | 12. Pet Care Tips | Daftar artikel dan halaman detail |
| Eksplorasi & Edukasi | 13. Adopsi Hewan | Daftar hewan adopsi dan halaman detail |
| Aktivitas | 14. Riwayat Pesanan & Booking | Daftar agregat dan filter status |

Semua data bersumber dari mock repository lokal. Tidak ada network call.

---

## 4. ONBOARDING STRATEGY — HYBRID

PetCare menggunakan strategi onboarding tiga lapis untuk memastikan pengguna baru mendaftarkan hewan peliharaannya.

### 4.1 Layer 1: Bottom Sheet (Setelah Login Pertama)

**Trigger:** Login berhasil dan `petsCount == 0`.

**Waktu kemunculan:** Setelah `context.go('/main/home')` dengan jeda 400 ms.

**Isi:**
- Ilustrasi.
- Sapaan kepada pengguna.
- Tombol **Daftarkan Anabul**.
- Tombol **Nanti Saja**.

**Aksi utama:** Navigasi ke `/pets/add?isOnboarding=true`.

**State:** Memeriksa `ref.watch(petsProvider).isEmpty`.

### 4.2 Layer 2: Banner di Home (Fallback)

**Trigger:** `petsCount == 0`, terlepas dari kondisi onboarding sebelumnya.

**Posisi:** Section ketiga pada Home, tepat di bawah search bar.

**Isi CTA:**

> Belum Ada Anabul? Tambah Anabul Sekarang

Banner tidak dapat di-dismiss sampai pengguna menambahkan hewan peliharaan.

### 4.3 Layer 3: Guard Dialog (Saat Membutuhkan Fitur)

**Trigger:** Pengguna mengetuk fitur yang membutuhkan data hewan peliharaan ketika `petsCount == 0`.

**Fitur yang membutuhkan pet:**
- Konsultasi.
- Booking klinik.
- Grooming.
- Rekam medis.
- Pengingat.

**Isi dialog:**

> Kamu belum punya anabul. Tambah dulu yuk!

**Aksi:** Tombol **Tambah Anabul** mengarahkan pengguna ke `/pets/add`.

**Implementasi:** Helper function `ensureHasPet(context, ref)` yang mengembalikan nilai boolean.

---

## 5. ALUR PENGGUNA UTAMA

### 5.1 Alur Onboarding Pet

```text
Login/Register
      ↓
    Home
      ↓
Bottom Sheet "Daftarkan Anabul?"
      ↓
  ┌───────────────┐
  │               │
Daftarkan      Nanti Saja
  │               │
Form Pet      Home + Banner
  │
Simpan
  │
Home + Kartu Anabul
```

### 5.2 Alur Konsultasi Dokter

```text
Home
  ↓
Konsultasi
  ↓
Pilih Dokter
  ↓
[Guard Pet]
  ↓
Pilih Pet
  ↓
Chat Room (Mock Stream)
  ↓
Selesai
  ↓
Aktivitas
```

### 5.3 Alur Pembelian Pet Shop

```text
Home
  ↓
Pet Shop
  ↓
Jelajah Produk
  ↓
Detail Produk
  ↓
Tambah ke Keranjang (Lokal)
  ↓
Cart
  ↓
Checkout
  ↓
Pesanan Berhasil
  ↓
Aktivitas
```

### 5.4 Alur Booking Klinik/Grooming

```text
Home
  ↓
Klinik/Grooming
  ↓
Pilih Klinik
  ↓
[Guard Pet]
  ↓
Pilih Pet
  ↓
Pilih Tanggal & Waktu
  ↓
Konfirmasi
  ↓
Aktivitas
```

### 5.5 Alur Rekam Medis

```text
Home
  ↓
Pets
  ↓
Pilih Pet
  ↓
Tab Rekam Medis
  ↓
Tambah Rekam Medis
  ↓
Form
  ↓
Simpan
  ↓
Daftar Rekam Medis
```

---

## 6. ARSITEKTUR FRONTEND

### 6.1 Layer Architecture

```text
┌─────────────────────────────────────────────────┐
│                    UI LAYER                     │
│           Widgets, Screens, Components          │
│                                                 │
│  - Konsumsi state via ref.watch()               │
│  - Trigger action via ref.read().notifier       │
└───────────────────────┬─────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────┐
│                   STATE LAYER                   │
│             Riverpod Providers / Notifiers      │
│                                                 │
│  - AsyncNotifier untuk data async               │
│  - Notifier untuk state lokal                   │
│  - Mengelola loading, error, success state      │
└───────────────────────┬─────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────┐
│                REPOSITORY LAYER                 │
│                 Mock Repositories               │
│                                                 │
│  - AuthRepo, PetRepo, ShopRepo, dan lainnya     │
│  - Return data dummy + delay simulasi           │
│  - Mudah diganti ke API di masa depan           │
└───────────────────────┬─────────────────────────┘
                        │
┌───────────────────────▼─────────────────────────┐
│                   DATA SOURCE                   │
│                                                 │
│   ┌──────────────┐    ┌──────────────────────┐  │
│   │  Mock JSON   │    │ SharedPreferences    │  │
│   │  (assets/)   │    │ Secure Storage       │  │
│   └──────────────┘    └──────────────────────┘  │
└─────────────────────────────────────────────────┘
```

### 6.2 Prinsip Arsitektur

- **Feature-Driven:** Setiap fitur memiliki folder tersendiri di dalam `features/`.
- **Separation of Concerns:** UI tidak boleh mengakses data secara langsung. Semua akses dilakukan melalui Repository.
- **Single Source of Truth:** State dikelola oleh Riverpod, bukan disimpan secara terpisah di setiap widget.
- **Immutable Model:** Model menggunakan `copyWith()` untuk memperbarui data.
- **Fail Gracefully:** Semua operasi asynchronous harus memiliki loading dan error state.
- **Backend-Ready:** Repository menggunakan interface agar implementasinya dapat diganti ketika backend tersedia.

---

## 7. STRUKTUR FOLDER FLUTTER

Folder `providers/` hanya dibuat jika fitur memiliki state yang perlu dikelola menggunakan Riverpod. Fitur seperti `main_nav` yang hanya menangani shell navigation tidak memerlukan folder tersebut.

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   └── app_sizes.dart
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── text_styles.dart
│   ├── utils/
│   │   ├── date_formatter.dart
│   │   ├── currency_formatter.dart
│   │   ├── validators.dart
│   │   └── pet_guard.dart
│   ├── services/
│   │   ├── secure_storage_service.dart
│   │   ├── prefs_service.dart
│   │   └── notification_service.dart
│   ├── errors/
│   │   └── app_exception.dart
│   └── widgets/
│       ├── custom_button.dart
│       ├── custom_text_field.dart
│       ├── empty_state.dart
│       ├── error_widget.dart
│       ├── loading_widget.dart
│       └── custom_snackbar.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── pet_model.dart
│   │   ├── vet_model.dart
│   │   ├── product_model.dart
│   │   ├── order_model.dart
│   │   ├── consultation_model.dart
│   │   ├── message_model.dart
│   │   ├── booking_model.dart
│   │   ├── reminder_model.dart
│   │   ├── health_record_model.dart
│   │   ├── article_model.dart
│   │   └── adoption_model.dart
│   ├── mocks/
│   │   ├── mock_pets.dart
│   │   ├── mock_vets.dart
│   │   ├── mock_products.dart
│   │   ├── mock_articles.dart
│   │   ├── mock_adoptions.dart
│   │   └── mock_promos.dart
│   └── repositories/
│       ├── auth_repo.dart
│       ├── pet_repo.dart
│       ├── vet_repo.dart
│       ├── product_repo.dart
│       ├── order_repo.dart
│       ├── consultation_repo.dart
│       ├── booking_repo.dart
│       ├── reminder_repo.dart
│       ├── health_repo.dart
│       ├── article_repo.dart
│       └── adoption_repo.dart
│
├── features/
│   ├── auth/
│   │   ├── providers/
│   │   │   └── auth_provider.dart
│   │   ├── screens/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   └── widgets/
│   ├── main_nav/
│   │   └── screens/
│   │       └── main_nav_screen.dart
│   ├── home/
│   │   ├── providers/
│   │   │   └── home_provider.dart
│   │   ├── screens/
│   │   │   └── home_screen.dart
│   │   └── widgets/
│   ├── pets/
│   │   ├── providers/
│   │   │   ├── pets_provider.dart
│   │   │   └── pet_form_provider.dart
│   │   ├── screens/
│   │   │   ├── pets_list_screen.dart
│   │   │   ├── pet_form_screen.dart
│   │   │   └── pet_detail_screen.dart
│   │   └── widgets/
│   ├── consultation/
│   │   ├── providers/
│   │   │   ├── vets_provider.dart
│   │   │   └── chat_provider.dart
│   │   ├── screens/
│   │   │   ├── vet_list_screen.dart
│   │   │   └── chat_room_screen.dart
│   │   └── widgets/
│   ├── booking/
│   │   ├── providers/
│   │   │   └── booking_provider.dart
│   │   ├── screens/
│   │   └── widgets/
│   ├── shop/
│   │   ├── providers/
│   │   │   ├── products_provider.dart
│   │   │   └── cart_provider.dart
│   │   ├── screens/
│   │   │   ├── shop_screen.dart
│   │   │   ├── product_detail_screen.dart
│   │   │   ├── cart_screen.dart
│   │   │   └── checkout_screen.dart
│   │   └── widgets/
│   ├── activity/
│   │   ├── providers/
│   │   │   └── activity_provider.dart
│   │   ├── screens/
│   │   └── widgets/
│   ├── articles/
│   │   ├── providers/
│   │   │   └── articles_provider.dart
│   │   ├── screens/
│   │   └── widgets/
│   ├── adoption/
│   │   ├── providers/
│   │   │   └── adoption_provider.dart
│   │   ├── screens/
│   │   └── widgets/
│   └── profile/
│       ├── providers/
│       │   └── profile_provider.dart
│       ├── screens/
│       └── widgets/
│
├── routes/
│   ├── app_routes.dart
│   └── app_router.dart
│
├── main.dart
└── app.dart
```

---

## 8. STATE MANAGEMENT DENGAN RIVERPOD

### 8.1 Jenis Provider yang Digunakan

| Provider | Kapan Digunakan |
|---|---|
| `Provider` | Dependency injection untuk repository dan service |
| `FutureProvider` | Data read-only yang diambil satu kali |
| `StreamProvider` | Data realtime, seperti chat mock |
| `AsyncNotifierProvider` | Data asynchronous dengan operasi mutasi |
| `NotifierProvider` | State lokal sinkron, seperti cart dan filter |
| `StateProvider` | State sederhana, seperti counter dan toggle, jika sesuai dengan versi Riverpod yang digunakan |

### 8.2 Contoh Struktur Provider

#### Dependency Injection

```dart
final petRepoProvider = Provider<PetRepo>((ref) => PetRepo());
```

#### Async Data (List Pet)

```dart
final petsProvider =
    AsyncNotifierProvider<PetsNotifier, List<Pet>>(() {
  return PetsNotifier();
});

class PetsNotifier extends AsyncNotifier<List<Pet>> {
  @override
  Future<List<Pet>> build() async {
    return ref.read(petRepoProvider).getPets();
  }

  Future<void> addPet(Pet pet) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await ref.read(petRepoProvider).createPet(pet);
      return ref.read(petRepoProvider).getPets();
    });
  }
}
```

#### Stream Data (Chat)

```dart
final chatMessagesProvider =
    StreamProvider.family<List<Message>, int>(
  (ref, consultationId) {
    return ref
        .read(consultationRepoProvider)
        .streamMessages(consultationId);
  },
);
```

#### Local State (Cart)

```dart
final cartProvider =
    NotifierProvider<CartNotifier, List<CartItem>>(() {
  return CartNotifier();
});
```

### 8.3 Aturan Utama

- UI hanya menggunakan `ref.watch()` untuk mendengarkan state dan `ref.read()` untuk menjalankan aksi satu kali.
- Mutation harus dilakukan melalui method di Notifier, bukan dengan mengubah state secara langsung dari UI.
- Side effect seperti navigasi dan snackbar dilakukan di UI, bukan di provider.
- Provider tidak boleh mengimpor Flutter widgets, kecuali jika diperlukan untuk foundation yang relevan.

---

## 9. ROUTING DENGAN GO_ROUTER

### 9.1 Struktur Route

```text
/login
/register

/main
├── /main/home
├── /main/shop
├── /main/activity
└── /main/profile

/pets
├── /pets/add
└── /pets/:id

/consultation
├── /consultation/vets
└── /consultation/chat/:id

/booking
├── /booking/clinic/:id
└── /booking/grooming/:id

/shop
├── /shop/product/:id
├── /shop/cart
└── /shop/checkout

/articles
└── /articles/:id

/adoption
└── /adoption/:id
```

### 9.2 Auth Guard

```dart
GoRouter(
  redirect: (context, state) {
    final isLoggedIn = ref.read(authProvider).isLoggedIn;

    final isAuthRoute =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/register';

    if (!isLoggedIn && !isAuthRoute) {
      return '/login';
    }

    if (isLoggedIn && isAuthRoute) {
      return '/main/home';
    }

    return null;
  },
  routes: [
    // Definisi route aplikasi
  ],
)
```

> Catatan implementasi: Contoh di atas merupakan gambaran logika. Tipe state pada `authProvider`, akses ke `ref`, dan konfigurasi router perlu disesuaikan dengan implementasi Riverpod dan go_router yang digunakan.

### 9.3 Nested Routing

Bottom navigation menggunakan `StatefulShellRoute.indexedStack` agar:

- Setiap tab memiliki navigator sendiri.
- State antar-tab tidak hilang ketika pengguna berpindah tab.
- Perilaku tombol Back mengikuti navigasi masing-masing tab.

---

## 10. DATA LAYER & MOCK REPOSITORY

### 10.1 Konsep

Karena aplikasi bersifat standalone, semua data bersumber dari mock repository yang menyimpan data di memori (*in-memory*) dan/atau file JSON di dalam `assets/`.

Repository dirancang menggunakan interface agar mudah diganti dengan API di masa depan.

Contoh:

- `AuthRepository` sebagai abstract repository.
- `MockAuthRepository` sebagai implementasi yang digunakan sekarang.
- `ApiAuthRepository` sebagai alternatif implementasi ketika backend tersedia.

### 10.2 Simulasi Delay

Setiap method repository memberikan delay 300–800 ms agar loading state terlihat realistis.

```dart
Future<List<Pet>> getPets() async {
  await Future.delayed(const Duration(milliseconds: 500));
  return List.from(_pets);
}
```

### 10.3 Contoh MockPetRepo

```dart
class MockPetRepo implements PetRepo {
  final List<Pet> _pets = [...mockPets];

  @override
  Future<List<Pet>> getPets() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_pets);
  }

  @override
  Future<Pet> createPet(Pet pet) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final newPet = pet.copyWith(id: _pets.length + 1);
    _pets.add(newPet);

    return newPet;
  }

  @override
  Future<void> deletePet(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _pets.removeWhere((p) => p.id == id);
  }
}
```

### 10.4 Mock Auth

Login berhasil apabila:

- Format email valid.
- Password minimal 6 karakter.

Tidak ada validasi server. Token disimpan sebagai string dummy di secure storage.

### 10.5 Data Mock dari Assets

Data dalam jumlah besar, seperti produk, artikel, dan adopsi, disimpan di `assets/data/*.json` dan dimuat ketika aplikasi dijalankan.

### 10.6 Migrasi ke API

Ketika backend tersedia:

1. Buat implementasi baru, misalnya `ApiPetRepo implements PetRepo`.
2. Ganti implementasi repository pada provider.
3. Pertahankan kontrak repository agar UI tidak perlu diubah.

Contoh:

```dart
final petRepoProvider = Provider<PetRepo>((ref) {
  return ApiPetRepo();
});
```

---

## 11. REALTIME CHAT (MOCK STREAM)

### 11.1 Konsep

Chat disimulasikan menggunakan `StreamController` di dalam aplikasi.

Alurnya:

1. Pengguna mengirim pesan.
2. Pesan pengguna dimasukkan ke dalam daftar pesan.
3. Setelah jeda 1–2 detik, aplikasi menghasilkan balasan otomatis dari dokter hewan.
4. Stream mengirimkan daftar pesan terbaru sehingga UI diperbarui.

### 11.2 Contoh Implementasi

```dart
class MockConsultationRepo {
  final Map<int, StreamController<List<Message>>> _controllers = {};

  Stream<List<Message>> streamMessages(int consultationId) {
    _controllers.putIfAbsent(
      consultationId,
      () => StreamController<List<Message>>.broadcast(),
    );

    return _controllers[consultationId]!.stream;
  }

  Future<void> sendMessage(
    int consultationId,
    Message msg,
  ) async {
    // Tambahkan pesan pengguna.
    // Tunggu sekitar 1,5 detik.
    // Tambahkan balasan otomatis dari dokter hewan.
    // Kirim daftar pesan terbaru ke stream.
  }
}
```

### 11.3 Template Balasan Otomatis

Contoh balasan dari dokter hewan:

- "Baik, bisa dijelaskan lebih detail gejalanya?"
- "Sudah berapa lama kondisi ini terjadi?"
- "Apakah nafsu makan anabul masih normal?"
- "Sebaiknya dibawa ke klinik untuk pemeriksaan lanjutan ya."

> Implementasi final perlu menambahkan penyimpanan daftar pesan, pemanggilan `add()` pada stream controller, typing indicator jika diperlukan, serta penanganan dan penutupan `StreamController` agar tidak terjadi memory leak.

---

## 12. LOCAL STORAGE

### 12.1 Secure Storage

Gunakan `flutter_secure_storage` untuk menyimpan:

- Sesi login.
- User ID.

### 12.2 Shared Preferences

Gunakan `shared_preferences` untuk menyimpan:

- Cart items agar tidak hilang ketika aplikasi ditutup.
- Flag onboarding, misalnya apakah bottom sheet sudah pernah ditampilkan.
- Filter terakhir (opsional).
- Preferensi tema (jika tersedia).

### 12.3 Menghapus Data Saat Logout

```dart
Future<void> logout() async {
  await secureStorage.deleteAll();
  await prefs.clear();
  ref.read(cartProvider.notifier).clear();
}
```

> Catatan: `clear()` pada preferences menghapus seluruh data preferences aplikasi. Jika terdapat pengaturan yang ingin dipertahankan, gunakan penghapusan berdasarkan key yang relevan. Pastikan cart, sesi, dan provider lain disinkronkan sesuai kebijakan logout.

---

## 13. PUSH NOTIFICATION LOKAL

Gunakan `flutter_local_notifications` untuk mengelola:

- Pengingat vaksin berdasarkan jadwal.
- Pengingat obat secara harian atau sesuai jadwal.
- Pengingat grooming setiap bulan.

### 13.1 Alur Notifikasi

1. Pengguna menambahkan reminder melalui UI.
2. Data reminder disimpan melalui provider dan repository.
3. Aplikasi menjadwalkan notifikasi lokal menggunakan `zonedSchedule`.
4. Notifikasi muncul sesuai jadwal yang ditentukan, termasuk ketika aplikasi tidak sedang terbuka, selama didukung oleh konfigurasi dan kebijakan sistem operasi.

### 13.2 Permission

Android 13 ke atas memerlukan izin notifikasi runtime.

Contoh permintaan izin:

```dart
await flutterLocalNotificationsPlugin
    .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
    ?.requestNotificationsPermission();
```

Pastikan konfigurasi timezone, inisialisasi plugin, izin platform, dan penjadwalan notifikasi diselesaikan sebelum fitur digunakan.

---

## 14. ERROR HANDLING & LOADING STATE

### 14.1 Standar Async State

Setiap pengambilan data harus menangani tiga state utama.

| State | Penanganan |
|---|---|
| Loading | Menampilkan skeleton, shimmer, atau spinner |
| Error | Menampilkan ErrorWidget dengan tombol "Coba Lagi" |
| Success | Menampilkan data yang berhasil diperoleh |

Riverpod menyediakan `AsyncValue` untuk membantu menangani kondisi tersebut.

Contoh:

```dart
ref.watch(petsProvider).when(
  loading: () => LoadingWidget(),
  error: (e, st) => ErrorWidget(
    message: e.toString(),
  ),
  data: (pets) => PetList(pets: pets),
);
```

### 14.2 Error Types

| Jenis Error | Penanganan |
|---|---|
| Validation error (form) | Menampilkan pesan error pada field form |
| Not found (data kosong) | Menampilkan EmptyState |
| Unexpected error | Menampilkan snackbar "Terjadi kesalahan" |
| Timeout simulasi | Menampilkan snackbar dan menyediakan retry |

### 14.3 Custom Exception

```dart
class AppException implements Exception {
  final String message;
  final Map<String, dynamic>? errors;

  AppException({
    required this.message,
    this.errors,
  });
}
```

---

## 15. TECH STACK

| Layer | Teknologi | Alasan |
|---|---|---|
| Framework | Flutter 3.x | Cross-platform dengan satu codebase |
| State Management | Riverpod | Modern, testable, dan mengurangi boilerplate |
| Router | go_router | Mendukung nested routing dan guard |
| Secure Storage | flutter_secure_storage | Menyimpan sesi login |
| Local Storage | shared_preferences | Menyimpan cart dan flag onboarding |
| Notifications | flutter_local_notifications | Pengingat vaksin dan obat |
| Image Picker | image_picker | Mengunggah foto pet dari galeri |
| Fonts | google_fonts | Menggunakan font Poppins |
| Date | intl | Format tanggal dan mata uang |
| Design Tool | Google Stitch | Pembuatan UI berbantuan AI |

---

## 16. DEPENDENCIES

Berikut konfigurasi dependencies yang direncanakan pada `pubspec.yaml`.

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management & Routing
  flutter_riverpod: ^2.6.1
  go_router: ^14.6.2

  # Storage
  flutter_secure_storage: ^9.2.2
  shared_preferences: ^2.3.3

  # UI & Media
  google_fonts: ^6.2.1
  image_picker: ^1.1.2

  # Notifications
  flutter_local_notifications: ^18.0.1
  timezone: ^0.10.0

  # Utilities
  intl: ^0.20.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^5.0.0

flutter:
  uses-material-design: true

  assets:
    - assets/images/
    - assets/icons/
    - assets/data/
```

> Versi dependencies di atas merupakan versi yang direncanakan dalam PRD. Periksa kompatibilitas paket dengan versi Flutter dan Dart yang terpasang sebelum instalasi.

---

## 17. ENVIRONMENT & CONFIG

Karena aplikasi berjalan secara standalone, file `.env` belum diperlukan.

Semua konfigurasi aplikasi ditempatkan di:

```text
lib/core/constants/
```

Jika backend ditambahkan di masa depan, konfigurasi dapat diperluas dengan:

```text
lib/
└── core/
    └── config/
        └── api_endpoints.dart
```

File `.env` dapat ditambahkan apabila diperlukan untuk konfigurasi lingkungan. Hindari menyimpan secret sensitif secara langsung di dalam aplikasi mobile karena nilai yang dibundel ke APK dapat diekstrak.

---

## 18. NON-FUNCTIONAL REQUIREMENTS

### 18.1 Performance

- Waktu loading screen kurang dari 2 detik pada kondisi pengujian yang ditentukan.
- Scroll berjalan dengan target 60 FPS pada perangkat yang mendukung.
- Balasan chat simulasi muncul dalam waktu kurang dari 2 detik.
- Ukuran APK ditargetkan kurang dari 30 MB.

### 18.2 Usability

- Minimum touch target sebesar 44 × 44 dp.
- Kontras teks memenuhi WCAG AA.
- Pesan error jelas dan dapat ditindaklanjuti.
- Semua operasi asynchronous memiliki loading state.
- Daftar data menggunakan skeleton loader jika sesuai, bukan hanya spinner.

### 18.3 Compatibility

- Android 8.0+ (API 26+).
- iOS 12+ sebagai target awal, dengan verifikasi terhadap dukungan minimum versi plugin.
- Ukuran layar 4,7–7 inci.
- Orientasi portrait saja.

### 18.4 Accessibility

- Semua tombol memiliki semantic label.
- Mendukung text scaling tanpa overflow.
- Warna bukan satu-satunya indikator; gunakan ikon atau teks tambahan.

---

## 19. DESIGN SYSTEM SUMMARY

Detail lengkap tersedia di `04_DESIGN_SYSTEM.md`.

| Aspek | Nilai |
|---|---|
| Primary Color | `#1B9AAA` (Teal) |
| Gradient Background | `#A8E6CF` → `#B3E5FC` |
| Font | Poppins |
| Card Radius | 16 px |
| Button Radius | 12 px |
| Bottom Navigation | 4 tab: Beranda, Shop, Aktivitas, Profil |

---

## 20. SPRINT PLAN

| Sprint | Fokus | Deliverable |
|---|---|---|
| Sprint 0 | Setup Flutter, dependencies, struktur folder, theme, mock data | Skeleton app berjalan |
| Sprint 1 | Auth UI (login/register), mock auth, session | APK login dan redirect |
| Sprint 2 | Main navigation (4 tab), Pet CRUD, hybrid onboarding | Bottom sheet, banner, dan guard berjalan |
| Sprint 3 | Chat UI dan mock stream | Simulasi chat berfungsi |
| Sprint 4 | Booking UI untuk klinik dan grooming | Booking flow berfungsi |
| Sprint 5 | Shop UI, cart, checkout | E-commerce flow berfungsi |
| Sprint 6 | Rekam medis, pengingat, notifikasi lokal, artikel, adopsi | Fitur pelengkap berfungsi |
| Sprint 7 | Profil, aktivitas agregat, polishing | Seluruh fitur selesai |
| Sprint 8 | Testing, bug fixing, build APK | APK final |

---

## 21. RISIKO & MITIGASI

| Risiko | Dampak | Mitigasi |
|---|---|---|
| Data mock hilang saat restart | Pengguna kehilangan data | Simpan data penting seperti cart dan session ke storage |
| Terlalu banyak data hardcoded | Sulit dipelihara | Simpan mock data berukuran besar di `assets/data/*.json` |
| Chat mock terasa tidak natural | UX kurang baik | Gunakan template balasan natural dan typing indicator |
| State tidak sinkron antar-tab | UI tidak konsisten | Gunakan `StatefulShellRoute` dan provider global |
| Asset gambar terlalu besar | APK melebihi target ukuran | Kompres asset dan gunakan WebP |
| Font Poppins tidak dirender | UI tidak konsisten | Periksa `google_fonts` atau bundle font secara manual |
| Layout overflow di layar kecil | UI rusak | Uji di layar kecil dan gunakan `SingleChildScrollView`, `Flexible`, atau layout adaptif |

---

## 22. METRIK KEBERHASILAN

Aplikasi dianggap memenuhi target apabila:

- [ ] APK dapat diinstal dan dibuka tanpa crash.
- [ ] Seluruh 14 fitur utama memiliki UI yang berfungsi.
- [ ] Hybrid onboarding berjalan: bottom sheet, banner, dan guard.
- [ ] Chat simulasi berfungsi dengan balasan otomatis.
- [ ] Sesi login tersimpan sehingga pengguna tidak perlu login ulang.
- [ ] Cart tetap tersimpan setelah aplikasi ditutup.
- [ ] Notifikasi reminder muncul sesuai jadwal dan izin sistem.
- [ ] Navigasi berjalan lancar tanpa kehilangan state antar-tab.
- [ ] Tidak ada error di console selama alur utama pengujian.
- [ ] UI konsisten dengan design system.

---

## 23. REFERENSI

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [go_router Documentation](https://pub.dev/packages/go_router)
- [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications)
- [Google Stitch](https://stitch.withgoogle.com/)
- Design System: `04_DESIGN_SYSTEM.md`

---

## CHECKLIST SETUP (SPRINT 0)

- [ ] Buat project Flutter dengan perintah `flutter create petcare`.
- [ ] Tambahkan dependencies pada `pubspec.yaml` sesuai Section 16.
- [ ] Buat struktur folder sesuai Section 7.
- [ ] Buat file `app_colors.dart`, `app_sizes.dart`, `text_styles.dart`, dan `app_theme.dart`.
- [ ] Buat folder `assets/images/`, `assets/icons/`, dan `assets/data/`.
- [ ] Buat mock data JSON di `assets/data/`.
- [ ] Buat `main.dart` dengan `ProviderScope`.
- [ ] Buat `app_router.dart` dengan route minimal untuk login, register, dan main.
- [ ] Jalankan aplikasi dan pastikan tidak ada error.
- [ ] Pastikan halaman login tampil dengan benar.

---

**Dokumen:** `01_PRD_Flutter.md`  
**Proyek:** PetCare  
**Versi:** 3.0 (Flutter Only)  
**Platform:** Flutter Mobile Application
