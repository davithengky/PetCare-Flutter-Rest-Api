/// Data foto bawaan (preset) untuk anabul/anabul dan foto default per spesies.
///
/// Dipakai saat menambah/mengedit anabul (pilih foto) dan sebagai fallback
/// ketika sebuah anabul belum memiliki `photoUrl` sendiri.
class PetPhotoOption {
  /// URL gambar (langsung, dari images.unsplash.com).
  final String url;

  /// Label singkat untuk ditampilkan di galeri pilihan.
  final String label;

  /// Spesies pemilik foto: 'Kucing' | 'Anjing'.
  final String species;

  const PetPhotoOption({
    required this.url,
    required this.label,
    required this.species,
  });
}

/// Foto default ketika spesies anabul adalah Kucing.
const String _catPhotoDefault =
    'https://images.unsplash.com/photo-1536589961747-e239b2abbec2?w=600&q=80&fit=crop';

/// Foto default ketika spesies anabul adalah Anjing.
const String _dogPhotoDefault =
    'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=600&q=80&fit=crop';

/// Daftar foto bawaan yang bisa dipilih pengguna saat menambah/mengedit anabul.
const List<PetPhotoOption> petPhotoPresets = [
  // ---------- Kucing ----------
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1536589961747-e239b2abbec2?w=600&q=80&fit=crop',
    label: 'Putih Coklat',
    species: 'Kucing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1498100152307-ce63fd6c5424?w=600&q=80&fit=crop',
    label: 'Tuxedo',
    species: 'Kucing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1596854372745-0906a0593bca?w=600&q=80&fit=crop',
    label: 'Oren',
    species: 'Kucing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1515002246390-7bf7e8f87b54?w=600&q=80&fit=crop',
    label: 'Tabby',
    species: 'Kucing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1615789591457-74a63395c990?w=600&q=80&fit=crop',
    label: 'Putih Hitam',
    species: 'Kucing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1604430352727-c0555f882e01?w=600&q=80&fit=crop',
    label: 'Anak Oren',
    species: 'Kucing',
  ),

  // ---------- Anjing ----------
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1558788353-f76d92427f16?w=600&q=80&fit=crop',
    label: 'Golden',
    species: 'Anjing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1518020382113-a7e8fc38eac9?w=600&q=80&fit=crop',
    label: 'Hitam',
    species: 'Anjing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1586671267731-da2cf3ceeb80?w=600&q=80&fit=crop',
    label: 'Labrador',
    species: 'Anjing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1629740067905-bd3f515aa739?w=600&q=80&fit=crop',
    label: 'Coklat Putih',
    species: 'Anjing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1619980296991-5c0d64b23950?w=600&q=80&fit=crop',
    label: 'Puppy',
    species: 'Anjing',
  ),
  PetPhotoOption(
    url:
        'https://images.unsplash.com/photo-1593620659530-7f98c53de278?w=600&q=80&fit=crop',
    label: 'Coklat',
    species: 'Anjing',
  ),
];

/// Mengembalikan URL foto default sesuai spesies anabul.
///
/// Spesies selain 'Anjing' (mis. 'Kucing') akan memakai foto kucing.
String defaultPetPhotoUrl(String species) =>
    species.toLowerCase() == 'anjing' ? _dogPhotoDefault : _catPhotoDefault;
