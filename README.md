# 🐾 PetCare — Aplikasi Mobile All-in-One untuk Pemilik Hewan Peliharaan

> Kelola semua kebutuhan hewan peliharaan kamu dalam satu aplikasi

---

## 📋 Daftar Isi

- [Tentang Aplikasi](#-tentang-aplikasi)
- [Fitur Utama](#-fitur-utama)
- [Tech Stack](#-tech-stack)
- [Struktur Folder](#-struktur-folder)
- [Cara Menjalankan](#-cara-menjalankan)
- [Akun Demo](#-akun-demo)
- [Checklist Testing](#-checklist-testing-manual)
- [Build APK Release](#-build-apk-release)
- [Konvensi Kode](#-konvensi-kode)
- [Troubleshooting](#-troubleshooting)

---

## 🐶 Tentang Aplikasi

**PetCare** adalah aplikasi mobile Flutter yang dirancang sebagai platform all-in-one untuk pemilik hewan peliharaan. Pengguna bisa:

- Mendaftarkan & mengelola profil hewan peliharaan
- Booking jadwal kunjungan klinik hewan
- Berkonsultasi via **PetBot** (chatbot AI)
- Berbelanja produk hewan (makanan, obat, mainan, aksesoris)
- Melihat rekam medis hewan
- Mengatur pengingat vaksin & obat
- Membaca artikel tips perawatan hewan
- Mengadopsi hewan

---

## ✨ Fitur Utama

| No | Fitur | Status |
|---|---|---|
| 1 | Autentikasi (Login / Register) | Done |
| 2 | Manajemen Hewan Peliharaan | Done |
| 3 | Booking Klinik | Done |
| 4 | Konsultasi PetBot | Done |
| 5 | Pet Shop (Produk + Keranjang + Checkout) | Done |
| 6 | Rekam Medis | Done |
| 7 | Pengingat Vaksin/Obat | Done |
| 8 | Artikel Pet Care Tips | Done |
| 9 | Adopsi Hewan | Done |
| 10 | Profil & Edit Profil | Done |
| 11 | Riwayat Aktivitas (Booking + Order) | Done |
| 12 | Splash Screen | Done |

---

## 🛠 Tech Stack

| Kategori | Package | Versi |
|---|---|---|
| Framework | Flutter | 3.x |
| Bahasa | Dart | ^3.13.2 |
| State Management | flutter_riverpod | ^3.4.3 |
| Routing | go_router | ^18.0.2 |
| Font | google_fonts (Poppins) | ^9.0.0 |
| Penyimpanan Aman | flutter_secure_storage | ^11.2.0 |
| Penyimpanan Lokal | shared_preferences | ^2.5.6 |
| Notifikasi Lokal | flutter_local_notifications | ^22.3.1 |
| Zona Waktu | timezone | ^0.11.1 |
| Image Picker | image_picker | ^1.2.4 |
| Internasionalisasi | intl | ^0.20.3 |

---

## 📁 Struktur Folder

```
lib/
├── main.dart                        # Entry point
├── app.dart                         # MaterialApp + ProviderScope
├── core/
│   ├── constants/
│   │   ├── app_colors.dart          # Warna aplikasi (Design System)
│   │   └── app_sizes.dart           # Ukuran / spacing (xs..xxxl)
│   ├── theme/
│   │   └── text_styles.dart         # TextStyle (Poppins)
│   ├── utils/
│   │   ├── snackbar_helper.dart     # Helper snackbar (success, error, info)
│   │   ├── dialog_helper.dart       # Helper dialog konfirmasi
│   │   └── currency_formatter.dart  # Format Rupiah
│   ├── services/
│   │   └── notification_service.dart
│   └── widgets/
│       ├── loading_widget.dart      # CircularProgressIndicator + pesan
│       ├── error_widget.dart        # Error state (ikon + retry)
│       ├── empty_state.dart         # Empty state (ikon + pesan)
│       └── loading_skeleton.dart    # Skeleton loading animation
├── data/
│   ├── models/                      # Data models (fromJson/toJson/copyWith)
│   └── repositories/                # Mock repositories (in-memory)
├── features/                        # Feature-first structure
│   ├── splash/
│   ├── auth/
│   ├── home/
│   ├── pets/
│   ├── booking/
│   ├── consultation/
│   ├── shop/
│   ├── activity/
│   ├── articles/
│   ├── adoption/
│   └── profile/
└── routes/
    └── app_router.dart              # GoRouter konfigurasi
```

---

## 🚀 Cara Menjalankan

### Prerequisites

- Flutter SDK 3.x
- Android Studio / VS Code dengan Flutter extension
- Android SDK (untuk Android) atau Xcode (untuk iOS)

### Setup & Run

```bash
# 1. Masuk ke folder project
cd "d:\Project Mobile Final\flutter_application_1"

# 2. Install dependencies
flutter pub get

# 3. Verifikasi setup
flutter doctor

# 4. Jalankan (debug mode)
flutter run

# Pilih device:
flutter run -d android    # Android
flutter run -d chrome     # Web
flutter run -d windows    # Desktop
```

---

## 🔑 Akun Demo

| Email | Password | Keterangan |
|---|---|---|
| user@petcare.com | password123 | Akun user biasa |
| admin@petcare.com | admin123 | Akun admin |

> Aplikasi menggunakan **Mock Repository** — data tersimpan in-memory, tidak ada koneksi API/server.

---

## ✅ Checklist Testing Manual

### Autentikasi
- [ ] Splash Screen muncul lalu redirect ke Login
- [ ] Login valid → masuk ke Home
- [ ] Login invalid → tampil error
- [ ] Register lengkap → redirect Login
- [ ] Logout → kembali ke Login

### Home Screen
- [ ] Section Layanan PetCare: 4 ikon (Konsultasi, Pet Shop, Klinik, Grooming)
- [ ] Section Layanan Lainnya: 2 ikon grid (Rekam Medis, Adopsi)
- [ ] Section Pet Care Tips: 3 artikel preview card besar
- [ ] Tombol "Lihat Semua" → ke halaman artikel

### Hewan Peliharaan
- [ ] Daftar hewan tampil di tab Pets
- [ ] Tambah hewan → isi form → tersimpan
- [ ] Edit hewan → tersimpan
- [ ] Hapus hewan → konfirmasi dialog

### Rekam Medis
- [ ] Tab Rekam Medis di detail hewan → daftar record
- [ ] Tambah & hapus rekam medis

### Pengingat
- [ ] Tab Pengingat di detail hewan
- [ ] Tambah, toggle aktif/nonaktif, hapus reminder

### Booking Klinik
- [ ] Pilih klinik → isi form → konfirmasi
- [ ] Booking muncul di Aktivitas

### PetBot
- [ ] Ketik pesan → terima respons bot
- [ ] Tampilan chat bubble kiri/kanan

### Pet Shop
- [ ] Daftar produk + filter kategori + search
- [ ] Tambah ke keranjang → badge bertambah
- [ ] Update quantity di keranjang
- [ ] Hapus item → konfirmasi dialog
- [ ] Checkout → isi alamat → order terkonfirmasi
- [ ] Order muncul di Aktivitas

### Aktivitas
- [ ] Tab Booking & Pesanan
- [ ] Filter status berfungsi
- [ ] Tap item → ke detail

### Artikel
- [ ] Daftar artikel tampil
- [ ] Tap → halaman detail artikel

### Adopsi
- [ ] Daftar hewan adopsi + filter
- [ ] Tap → detail adopsi
- [ ] Tombol kontak berfungsi

### Profil
- [ ] Data user tampil (nama, email, foto)
- [ ] Statistik: total pets, bookings, orders
- [ ] Edit Profil → simpan → data terupdate
- [ ] Logout dengan konfirmasi

### UI/UX
- [ ] Loading state saat data dimuat
- [ ] Error state dengan tombol Retry
- [ ] Empty state jika tidak ada data
- [ ] Snackbar sukses/error tampil
- [ ] Tidak ada overflow / RenderFlex errors

---

## 📦 Build APK Release

### 1. Persiapan

```bash
flutter clean
flutter pub get
```

### 2. Konfigurasi Versi

Edit `pubspec.yaml`:
```yaml
version: 1.0.0+1   # version_name+version_code
```

### 3. Generate Keystore (Sekali Saja)

```bash
keytool -genkey -v -keystore petcare-release.jks ^
  -keyalg RSA -keysize 2048 -validity 10000 ^
  -alias petcare
```

Buat file `android/key.properties`:
```properties
storePassword=<password_keystore>
keyPassword=<password_key>
keyAlias=petcare
storeFile=../petcare-release.jks
```

### 4. Build APK

```bash
# Fat APK (semua arsitektur)
flutter build apk --release

# Per arsitektur (direkomendasikan)
flutter build apk --release --split-per-abi

# Output:
# build/app/outputs/flutter-apk/app-release.apk
# build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

### 5. Build App Bundle (Google Play)

```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

### 6. Install ke Device

```bash
flutter install
# atau
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## 📐 Konvensi Kode

### Warna — selalu dari AppColors

```dart
// Benar
color: AppColors.primaryTeal

// Salah
color: Color(0xFF00897B)
```

### Spacing — selalu dari AppSizes

```dart
// Benar
padding: EdgeInsets.all(AppSizes.md)  // 12

// Salah
padding: EdgeInsets.all(12)
```

### Text Style — selalu dari AppTextStyles

```dart
// Benar
style: AppTextStyles.heading2

// Salah
style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)
```

### State Management — Riverpod Notifier

```dart
// Benar
class PetNotifier extends AsyncNotifier<List<Pet>> { ... }

// Salah — jangan gunakan setState untuk state global
```

### Snackbar

```dart
SnackbarHelper.showSuccess(context, 'Data berhasil disimpan');
SnackbarHelper.showError(context, 'Terjadi kesalahan');
```

### Dialog Konfirmasi

```dart
final confirmed = await DialogHelper.showConfirm(
  context,
  title: 'Hapus Data',
  message: 'Apakah kamu yakin?',
);
if (confirmed) { /* lanjutkan */ }
```

---

## 🐛 Troubleshooting

### pub get gagal
```bash
flutter clean
flutter pub cache repair
flutter pub get
```

### Gradle build error
```bash
cd android
./gradlew clean
cd ..
flutter build apk --release
```

### Notifikasi tidak muncul (Android 13+)
Grant permission `POST_NOTIFICATIONS` di Settings → App → PetCare → Izin.

### image_picker tidak berfungsi
Grant permission `READ_EXTERNAL_STORAGE` / `READ_MEDIA_IMAGES`.

---

Made with love for pet lovers
