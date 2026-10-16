# PETCARE DESIGN SYSTEM

## Panduan Visual & Komponen UI

---

**Nama Proyek:** PetCare
**Versi Dokumen:** 1.0
**Referensi Visual:** Prototype PetCare (6 screen)
**Design Tool:** Google Stitch
**Platform:** Mobile (Flutter)

---

## DAFTAR ISI

1. [Design Principles](#1-design-principles)
2. [Color Palette](#2-color-palette)
3. [Typography](#3-typography)
4. [Spacing System](#4-spacing-system)
5. [Border Radius](#5-border-radius)
6. [Elevation & Shadow](#6-elevation--shadow)
7. [Components](#7-components)
8. [Screen Layout Guidelines](#8-screen-layout-guidelines)
9. [Iconography](#9-iconography)
10. [Animations & Transitions](#10-animations--transitions)
11. [Design References](#11-design-references)

---

## 1. DESIGN PRINCIPLES

PetCare mengadopsi 4 prinsip desain utama yang menjadi acuan seluruh UI.

| Prinsip | Deskripsi |
| :--- | :--- |
| **Friendly** | Ramah, hangat, tidak kaku — cocok untuk pemilik hewan |
| **Clean** | Banyak white space, hierarki jelas, tidak ramai |
| **Trustworthy** | Warna medis (teal), badge membership, rating jelas |
| **Modern** | Gradient halus, rounded corners, soft shadow |

---

## 2. COLOR PALETTE

### 2.1 Primary Colors

| Nama | Hex | Penggunaan |
| :--- | :--- | :--- |
| **Primary Teal** | `#1B9AAA` | Tombol utama, link, active state |
| **Primary Dark** | `#0F6E7C` | Header kartu anabul, gradient end |
| **Primary Light** | `#E0F2F4` | Background highlight, chip background |

### 2.2 Accent Colors

| Nama | Hex | Penggunaan |
| :--- | :--- | :--- |
| **Accent Yellow** | `#F9C846` | Badge GOLD MEMBER, promo, warning |
| **Accent Orange** | `#FF8C42` | Icon Pet Shop, badge diskon |
| **Accent Pink** | `#E91E63` | Icon Grooming |
| **Accent Purple** | `#9C27B0` | Icon Adopsi, badge PetCare Pay |
| **Accent Green** | `#4CAF50` | Icon Klinik, status SELESAI, sukses |
| **Accent Blue** | `#2196F3` | Icon Konsultasi, status DALAM PENGIRIMAN |
| **Accent Red** | `#E53935` | Error, tombol Keluar Akun, badge notif |

### 2.3 Neutral Colors

| Nama | Hex | Penggunaan |
| :--- | :--- | :--- |
| **White** | `#FFFFFF` | Card background, bottom nav |
| **Grey 50** | `#FAFAFA` | Background screen |
| **Grey 100** | `#F5F5F5` | Card secondary, chip default |
| **Grey 200** | `#EEEEEE` | Divider |
| **Grey 300** | `#E0E0E0` | Border input, border card |
| **Grey 500** | `#9E9E9E` | Text secondary, hint |
| **Grey 700** | `#616161` | Text medium |
| **Grey 900** | `#212121` | Text primary |

### 2.4 Gradient

| Nama | Value | Penggunaan |
| :--- | :--- | :--- |
| **Background Gradient** | `linear-gradient(180deg, #A8E6CF 0%, #B3E5FC 100%)` | Background semua screen |
| **Anabul Card Gradient** | `linear-gradient(135deg, #1B9AAA 0%, #0F6E7C 100%)` | Kartu Anabul Aktif |
| **Promo Yellow** | `linear-gradient(135deg, #FEF3C7 0%, #FDE68A 100%)` | Card promo kuning |
| **Promo Blue** | `linear-gradient(135deg, #DBEAFE 0%, #BFDBFE 100%)` | Card promo biru |

### 2.5 Semantic Colors

| Status | Background | Text |
| :--- | :--- | :--- |
| Success (SELESAI) | `#E8F5E9` | `#2E7D32` |
| Info (DALAM PENGIRIMAN) | `#E3F2FD` | `#1565C0` |
| Warning (TERBATAS) | `#FFF3E0` | `#E65100` |
| Error (DIBATALKAN) | `#FFEBEE` | `#C62828` |
| Neutral (PENDING) | `#F5F5F5` | `#616161` |

### 2.6 Implementasi Flutter

```dart
// core/constants/app_colors.dart
class AppColors {
  // Primary
  static const primaryTeal = Color(0xFF1B9AAA);
  static const primaryDark = Color(0xFF0F6E7C);
  static const primaryLight = Color(0xFFE0F2F4);

  // Accent
  static const accentYellow = Color(0xFFF9C846);
  static const accentOrange = Color(0xFFFF8C42);
  static const accentPink = Color(0xFFE91E63);
  static const accentPurple = Color(0xFF9C27B0);
  static const accentGreen = Color(0xFF4CAF50);
  static const accentBlue = Color(0xFF2196F3);
  static const accentRed = Color(0xFFE53935);

  // Neutral
  static const white = Color(0xFFFFFFFF);
  static const grey50 = Color(0xFFFAFAFA);
  static const grey100 = Color(0xFFF5F5F5);
  static const grey200 = Color(0xFFEEEEEE);
  static const grey300 = Color(0xFFE0E0E0);
  static const grey500 = Color(0xFF9E9E9E);
  static const grey700 = Color(0xFF616161);
  static const grey900 = Color(0xFF212121);

  // Semantic
  static const successBg = Color(0xFFE8F5E9);
  static const successText = Color(0xFF2E7D32);
  static const infoBg = Color(0xFFE3F2FD);
  static const infoText = Color(0xFF1565C0);
  static const warningBg = Color(0xFFFFF3E0);
  static const warningText = Color(0xFFE65100);
  static const errorBg = Color(0xFFFFEBEE);
  static const errorText = Color(0xFFC62828);
}
3. TYPOGRAPHY
Font Family: Poppins
Fallback: Inter, Roboto, sans-serif

## 3.1 Text Styles
| Nama | Size | Weight | Line Height | Penggunaan |
| --- | --- | --- | --- | --- |
| Display | 28sp | Bold (700) | 1.3 | Angka besar, hero |
| H1 | 24sp | Bold (700) | 1.3 | Judul halaman utama |
| H2 | 20sp | SemiBold (600) | 1.3 | Judul section |
| H3 | 18sp | SemiBold (600) | 1.3 | Judul card besar |
| H4 | 16sp | SemiBold (600) | 1.4 | Judul card, item list |
| Body Large | 16sp | Regular (400) | 1.5 | Body utama |
| Body | 14sp | Regular (400) | 1.5 | Body default |
| Body Medium | 14sp | Medium (500) | 1.5 | Body emphasized |
| Body Small | 12sp | Regular (400) | 1.4 | Subtitle, hint |
| Caption | 10sp | Regular (400) | 1.3 | Label kecil, badge |
| Button | 14sp | SemiBold (600) | 1.2 | Text di tombol |
| Overline | 10sp | SemiBold (600) | 1.2 | Label kategori (uppercase, letter-spacing 0.5) |

## 3.2 Contoh Penggunaan dari Prototype
Home Header:

"Selamat pagi, 👋" → Body Small, Grey 500

"Budi Santoso" → H2, Grey 900

Kartu Anabul Aktif:

"ANABUL AKTIF" → Overline, White 80%

"Milo" → H2, White

"Golden" → Body Small, White 80% (dalam badge)

"Vaksin berikutnya: 12 Okt" → Body Small, White

Section Title:

"Layanan PetCare" → H3, Grey 900

Service Card:

"Konsultasi" → Body Medium, Grey 900

"Chat dokter" → Body Small, Grey 500

Product Card:

"MAKANAN ANJING" → Overline, Accent Orange

"Royal Canin Maxi Adult..." → Body Medium, Grey 900

"Rp 285.000" → Body Large SemiBold, Primary Teal

"Rp 325.000" (strike) → Body Small, Grey 500

Activity Card:

"Chat Dokter" → Body Small, Grey 700

"drh. Anisa Rahma" → H4, Grey 900

"Keluhan: Milo tampak..." → Body Small, Grey 500

"SELESAI" → Caption, Success

Profile Screen:

"Budi Santoso" → H4, Grey 900

"budi.santoso@email.com" → Body Small, Grey 500

"PETCARE GOLD MEMBER" → Caption, Warning

## 3.3 Implementasi Flutter
```dart
// core/theme/text_styles.dart
class AppTextStyles {
  static const display = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const h1 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static const h2 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const h3 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  static const h4 = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const body = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  static const caption = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static const overline = TextStyle(
    fontFamily: 'Poppins',
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );
}
4. SPACING SYSTEM
Base unit: 4px (kelipatan 4)

| Token | Value | Penggunaan |
| --- | --- | --- |
| xs | 4 | Gap icon-text kecil, padding chip |
| sm | 8 | Gap antar elemen dalam card |
| md | 12 | Padding internal card kecil |
| lg | 16 | Padding standar card, gap antar section kecil |
| xl | 20 | Padding screen horizontal |
| 2xl | 24 | Gap antar section besar, padding screen besar |
| 3xl | 32 | Padding hero section |
```

4.1 Contoh Penerapan
Padding screen horizontal: 20px

Padding card: 16px

Gap antar section: 24px

Gap antar item dalam list: 12px

Gap icon-text dalam service card: 8px

## 4.2 Implementasi Flutter
```dart
// core/constants/app_sizes.dart
class AppSizes {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 20.0;
  static const xxl = 24.0;
  static const xxxl = 32.0;

  static const screenPadding = 20.0;
  static const cardPadding = 16.0;
  static const sectionGap = 24.0;
  static const listItemGap = 12.0;
}
5. BORDER RADIUS
| Token | Value | Penggunaan |
| --- | --- | --- |
| sm | 8 | Chip, badge, tag |
| md | 12 | Tombol, input field, icon container |
| lg | 16 | Card, container |
| xl | 24 | Bottom sheet (top only), modal |
| full | 999 | Avatar, tombol bulat, pill |
```

5.1 Implementasi Flutter
```dart
class AppRadius {
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const full = 999.0;
}
6. ELEVATION & SHADOW
| Level | Shadow | Penggunaan |
| --- | --- | --- |
```

| 0 | None (border only) | Card utama (border Grey 300) |
| --- | --- | --- |
| 1 | 0 1px 3px rgba(0,0,0,0.08) | Card elevated, mini card |
| 2 | 0 2px 8px rgba(0,0,0,0.10) | Kartu Anabul Aktif |
| 3 | 0 4px 12px rgba(0,0,0,0.12) | FAB, dropdown |
| 4 | 0 8px 24px rgba(0,0,0,0.15) | Bottom nav, modal |
Catatan: PetCare lebih mengandalkan border tipis (1px Grey 300) daripada shadow tebal, untuk tampilan yang clean.

7. COMPONENTS

## 7.1 Buttons
Primary Button

| Properti | Value |
| --- | --- |
| Background | Primary Teal (#1B9AAA) |
| Text | White, 14sp, SemiBold |
| Padding | 14 vertical, 20 horizontal |
| Radius | 12 |
| Height | 48 |
State:

Default: #1B9AAA

Pressed: #0F6E7C

Disabled: #B0BEC5

Secondary Button (Outline)

| Properti | Value |
| --- | --- |
| Background | Transparent |
| Border | 1.5px Primary Teal |
| Text | Primary Teal, 14sp, SemiBold |
| Padding | 14 vertical, 20 horizontal |
| Radius | 12 |
Text Button

| Properti | Value |
| --- | --- |
| Background | Transparent |
| Text | Primary Teal, 14sp, Medium |
| Padding | 8 vertical, 12 horizontal |
Icon Button

| Properti | Value |
| --- | --- |
| Size | 40x40 |
| Icon Size | 24 |
| Background | Transparent (default) atau Grey 100 (variant) |
| Radius | Full |

## 7.2 Input Fields
Text Field

| Properti | Value |
| --- | --- |
| Background | White |
| Border | 1px Grey 300 |
| Radius | 12 |
| Padding | 14 horizontal, 14 vertical |
| Hint Color | Grey 500 |
| Text Color | Grey 900 |
| Focus Border | 1.5px Primary Teal |
| Error Border | 1.5px Accent Red |
Search Bar

| Properti | Value |
| --- | --- |
| Background | Grey 100 (#F5F5F5) |
| Border | None |
| Radius | 12 |
| Height | 44 |
| Icon | Search, Grey 500, 20px (left) |
| Hint | "Cari dokter atau keluhan anabul...", Grey 500 |
| Filter Icon | Tune, Primary Teal (right) |

## 7.3 Cards
Standard Card

| Properti | Value |
| --- | --- |
| Background | White |
| Border | 1px Grey 300 |
| Radius | 16 |
| Padding | 16 |
| Shadow | None |
Elevated Card (Kartu Anabul)

| Properti | Value |
| --- | --- |
| Background | Gradient Primary Teal → Dark Teal |
| Radius | 16 |
| Padding | 16 |
| Shadow | Level 2 |
| Text Color | White |
Product Card

| Properti | Value |
| --- | --- |
| Background | White |
| Border | 1px Grey 300 |
| Radius | 16 |
| Padding | 12 |
| Image | Aspect 1:1, radius 12 |
Activity Card

| Properti | Value |
| --- | --- |
| Background | White |
| Border | 1px Grey 300 |
| Radius | 16 |
| Padding | 16 |
| Layout | Header row + body row + footer row |
Pet Mini Card

| Properti | Value |
| --- | --- |
| Background | White |
| Border | 1px Grey 300 (default) / 2px Primary Teal (selected) |
| Radius | 12 |
| Size | 80x100 |
| Content | Foto bulat + Nama + Breed |

## 7.4 Chips & Badges
Filter Chip (Default)

| Properti | Value |
| --- | --- |
| Background | White |
| Border | 1px Grey 300 |
| Text | Grey 700, 13sp, Medium |
| Padding | 12 horizontal, 8 vertical |
| Radius | 8 |
Filter Chip (Active)

| Properti | Value |
| --- | --- |
| Background | Primary Teal |
| Border | None |
| Text | White, 13sp, SemiBold |
Status Badge

| Properti | Value |
| --- | --- |
| Padding | 6 horizontal, 4 vertical |
| Radius | 6 |
| Text | Caption (10sp), SemiBold, UPPERCASE |
Varian Status:

| Status | Background | Text |
| --- | --- | --- |
| SELESAI | #E8F5E9 | #2E7D32 |
| DALAM PENGIRIMAN | #E3F2FD | #1565C0 |
| TERBATAS | #FFF3E0 | #E65100 |
| DIBATALKAN | #FFEBEE | #C62828 |
Badge Notifikasi

| Properti | Value |
| --- | --- |
| Size | 18x18 |
| Background | Accent Red |
| Text | White, 10sp, Bold |
| Radius | Full |
| Position | Top-right corner icon |
Membership Badge (GOLD MEMBER)

| Properti | Value |
| --- | --- |
| Background | Gradient Yellow (#FEF3C7 → #FDE68A) |
| Text | #E65100, 11sp, SemiBold |
| Padding | 10 horizontal, 4 vertical |
| Radius | Full |
| Icon | Star (filled, #F9C846) |

## 7.5 Avatar
User Avatar (Large)

| Properti | Value |
| --- | --- |
| Size | 56x56 |
| Radius | Full |
| Background | Primary Teal |
| Text | White, 20sp, Bold (initials) |
| Border | 2px White (optional) |
User Avatar (Small)

| Properti | Value |
| --- | --- |
| Size | 40x40 |
Pet Avatar (Circular)

| Properti | Value |
| --- | --- |
| Size | 60x60 (kartu anabul), 48x48 (list), 32x32 (mini) |
| Radius | Full |
| Border | 2px White |

## 7.6 Bottom Navigation
| Properti | Value |
| --- | --- |
| Background | White |
| Height | 60 |
| Elevation | 8 |
| Radius Top | 20 (optional) |
| Tab Count | 4 (Beranda, Shop, Aktivitas, Profil) |
| Icon Size | 24 |
| Label Size | 11sp, Medium |
| Active Color | Primary Teal |
| Inactive Color | Grey 500 |
| Badge | Accent Red dot (18x18) di tab Aktivitas |

## 7.7 Bottom Sheet
| Properti | Value |
| --- | --- |
| Background | White |
| Radius Top | 24 |
| Padding | 24 |
| Handle Bar | 40x4, Grey 300, radius full, margin bottom 20 |
| Drag | Enabled |
| Dismissible | Yes |

## 7.8 Gradient Background
| Properti | Value |
| --- | --- |
| Direction | Top to bottom |
| Colors | #A8E6CF → #B3E5FC |
| Opacity | 100% |
Implementasi Flutter:

```dart
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFA8E6CF),
        Color(0xFFB3E5FC),
      ],
    ),
  ),
)
8. SCREEN LAYOUT GUIDELINES
```

8.1 Header Pattern
| Properti | Value |
| --- | --- |
| Padding | 20 horizontal, 16 vertical |
| Layout | Row |
| Left | Avatar (56x56) + Column (greeting + name) |
| Right | IconButton (bell + badge) |
| Gap | 12 antar avatar & text |

## 8.2 Section Pattern
| Properti | Value |
| --- | --- |
| Padding | 20 horizontal |
| Gap Top | 24 (dari section sebelumnya) |
| Title | H3, Grey 900, margin bottom 12 |
| Content | Sesuai tipe (grid, list, scroll) |

## 8.3 List Item Pattern
| Properti | Value |
| --- | --- |
| Padding | 16 |
| Gap | 12 antar item |
| Card | Standard Card |
| Layout | Row (icon + content + trailing) |

## 8.4 Layout Breakdown dari Prototype
Home Screen:

Padding horizontal: 20
Gap antar section: 24
- Header (avatar + greeting + bell)
- Search bar (height 44)
- Kartu Anabul (gradient teal, radius 16, padding 16)
- Section "Layanan PetCare" (grid 2x2, gap 12)
- Section "Promo Spesial" (horizontal scroll)
- Section "Layanan Lainnya" (grid 3 kolom, gap 16)
Shop Screen:

Padding horizontal: 20
- Header + Cart icon (badge)
- Category chips (horizontal scroll, gap 8)
- Product grid (2 kolom, gap 12)
Activity Screen:

Padding horizontal: 20
- Header + Filter icon
- Filter chips (gap 8)
- Activity cards (gap 12)
Profile Screen:

Padding horizontal: 20
- Profile header card (avatar + nama + email + badge)
- Section "Anabul Saya" + tombol "+ Tambah"
- Pet mini cards (horizontal scroll, gap 8)
- Menu list (single card, divider antar item)
9. ICONOGRAPHY
Icon set: Material Icons (outlined style untuk konsistensi)

## 9.1 Service Icons
| Kategori | Icon | Color |
| --- | --- | --- |
| Konsultasi | chat_bubble_outline | Accent Blue |
| Pet Shop | shopping_bag_outlined | Accent Orange |
| Klinik | local_hospital_outlined | Accent Green |
| Grooming | content_cut | Accent Pink |
| Rekam Medis | description_outlined | Accent Blue |
| Adopsi | favorite_border | Accent Purple |
| Artikel | article_outlined | Accent Green |

## 9.2 Navigation Icons
| Tab | Icon | Active | Inactive |
| --- | --- | --- | --- |
| Beranda | home_outlined | Primary Teal | Grey 500 |
| Shop | shopping_bag_outlined | Primary Teal | Grey 500 |
| Aktivitas | receipt_long_outlined | Primary Teal | Grey 500 |
| Profil | person_outline | Primary Teal | Grey 500 |

## 9.3 Icon Container (Service Grid)
| Properti | Value |
| --- | --- |
| Size | 48x48 |
| Radius | 12 |
| Background | Accent color @ 15% opacity |
| Icon Size | 24 |
Contoh implementasi:

```dart
Container(
  width: 48, height: 48,
  decoration: BoxDecoration(
    color: AppColors.accentBlue.withOpacity(0.15),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Icon(
    Icons.chat_bubble_outline,
    color: AppColors.accentBlue,
    size: 24,
  ),
)
10. ANIMATIONS & TRANSITIONS
| Elemen | Durasi | Curve |
| --- | --- | --- |
| Page transition | 300ms | easeInOut |
| Button press | 150ms | easeOut |
| Bottom sheet | 250ms | easeOutCubic |
| Fade in card | 200ms | easeOut |
| Snackbar | 300ms | easeOut |
11. DESIGN REFERENCES
```

11.1 Screen dari Prototype
| Screen | File | Catatan |
| --- | --- | --- |
| Home (active pet) | screens/01_home_active_pet.png | Kartu anabul + Layanan PetCare |
| Home (empty state) | screens/02_home_empty.png | Banner onboarding |
| Profile | screens/03_profile.png | Header + Anabul Saya + Menu |
| Activity | screens/04_activity.png | Chat Dokter + Pet Shop Order |
| Shop | screens/05_shop.png | Grid 2 kolom + Category chips |
| Home (variant) | screens/06_home_variant.png | Referensi alternatif |

## 11.2 Catatan Visual Kunci
Kartu Anabul Aktif:

Gradient teal dari kiri atas ke kanan bawah

Watermark paw pattern (subtle)

Label "ANABUL AKTIF" uppercase kecil

Foto pet bulat dengan border putih

Badge umur (Golden) dengan background putih transparan

Icon switch di kanan atas (bulat putih)

Promo Card:

Promo kuning: gradient yellow, badge "TERBATAS" orange, tombol "Klaim"

Promo biru: gradient blue, badge "VAKSIN", text "Vaksin Sehat"

Service Grid:

Icon container 48x48 dengan background accent 15% opacity

Title + subtitle dalam card putih

Border tipis 1px Grey 300

Bottom Nav:

4 tab: Beranda, Shop, Aktivitas, Profil

Icon + label

Badge merah di tab Aktivitas

Background putih dengan rounded top
