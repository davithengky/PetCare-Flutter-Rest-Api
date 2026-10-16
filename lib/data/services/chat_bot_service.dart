/// Layanan bot berbasis keyword matching untuk menjawab pertanyaan seputar hewan peliharaan.
///
/// Digunakan oleh [MockConsultationRepo] sebagai mesin balasan otomatis PetBot.
class ChatBotService {
  // Private constructor — class ini hanya dipakai secara statis
  ChatBotService._();

  /// Pesan sambutan resmi PetBot PetCare Vet Clinic.
  static const String welcomeMessage =
      'Halo! 👋 Aku PetBot, asisten virtual dari PetCare Vet Clinic. '
      'Ada yang bisa aku bantu tentang anabulmu? '
      'Kamu bisa tanya soal vaksin, makanan, kesehatan, atau perawatan ya 🐾';

  /// Menghasilkan balasan berdasarkan kata kunci yang terdapat dalam [userMessage].
  /// Pencarian dilakukan secara case-insensitive.
  static String getReply(String userMessage) {
    final msg = userMessage.toLowerCase();

    // Sapaan
    if (_contains(msg, ['halo', 'hai', 'hello', 'hi'])) {
      return welcomeMessage;
    }

    // Cabang / Lokasi / Alamat / Dimana
    if (_contains(msg, ['cabang', 'lokasi', 'alamat', 'dimana'])) {
      return 'PetCare Vet Clinic punya 6 cabang:\n'
          '• Cabang Darmo — Jl. Raya Darmo No. 88, Surabaya\n'
          '• Cabang Gubeng — Jl. Gubeng Airlangga No. 45, Surabaya\n'
          '• Cabang Merr — Jl. Dr. Ir. H. Soekarno No. 120, Surabaya\n'
          '• Cabang Rungkut — Jl. Rungkut Industri No. 18, Surabaya\n'
          '• Cabang Sidoarjo — Jl. Ahmad Yani No. 55, Sidoarjo\n'
          '• Cabang Gresik — Jl. Veteran No. 32, Gresik\n\n'
          'Untuk booking, klik menu Klinik ya 🏥';
    }

    // Jam operasional
    if (_contains(msg, ['jam', 'buka', 'operasional', 'tutup'])) {
      return 'Jam operasional PetCare Vet Clinic:\n'
          '• Senin-Jumat: 08:00 - 21:00\n'
          '• Sabtu: 08:00 - 20:00\n'
          '• Minggu: 09:00 - 17:00\n\n'
          'Beberapa cabang mungkin punya jam berbeda. Cek di halaman Pilih Klinik ya 🕐';
    }

    // Biaya / Harga / Tarif
    if (_contains(msg, ['harga', 'biaya', 'tarif', 'berapa'])) {
      return 'Estimasi biaya di PetCare Vet Clinic:\n'
          '• Konsultasi umum: mulai Rp 50.000\n'
          '• Vaksinasi: mulai Rp 150.000\n'
          '• Grooming: mulai Rp 75.000\n\n'
          'Biaya final ditentukan setelah pemeriksaan dokter 🏥';
    }

    // Vaksinasi
    if (_contains(msg, ['vaksin', 'imunisasi'])) {
      return 'Jadwal vaksin ideal:\n'
          '• Kucing: mulai umur 6-8 minggu, booster tiap 3-4 minggu sampai umur 16 minggu, lalu booster tahunan\n'
          '• Anjing: mulai umur 6-8 minggu, booster tiap 2-4 minggu sampai umur 16 minggu, lalu booster tahunan\n\n'
          'Konsultasikan jadwal spesifik ke dokter ya 🐾';
    }

    // Makanan & nutrisi
    if (_contains(msg, ['makan', 'makanan', 'nutrisi'])) {
      return 'Tips makanan sehat:\n'
          '• Kucing: protein hewani tinggi, hindari bawang & cokelat\n'
          '• Anjing: seimbang protein, lemak, karbohidrat\n'
          '• Beri air minum cukup\n'
          '• Hindari makanan manusia yang berbahaya\n\n'
          'Kalau ada keluhan pencernaan, segera ke dokter ya.';
    }

    // Sakit / demam / lemas
    if (_contains(msg, ['sakit', 'demam', 'lemas'])) {
      return 'Kalau anabul lemas atau demam, sebaiknya segera dibawa ke klinik terdekat. Sambil menunggu:\n'
          '• Pastikan tetap minum\n'
          '• Beri tempat nyaman & hangat\n'
          '• Jangan beri obat manusia\n\n'
          'Klik menu Klinik untuk booking ya 🏥';
    }

    // Kutu / flea / tick
    if (_contains(msg, ['kutu', 'flea', 'tick'])) {
      return 'Cara atasi kutu:\n'
          '• Mandikan dengan shampoo anti-kutu\n'
          '• Pakai obat tetes kutu dari dokter\n'
          '• Bersihkan tempat tidur & lingkungan\n'
          '• Rutin grooming\n\n'
          'Kalau parah, konsultasi ke dokter ya 🐛';
    }

    // Mandi / grooming
    if (_contains(msg, ['mandi', 'grooming'])) {
      return 'Jadwal mandi ideal:\n'
          '• Kucing: 1x per 4-6 minggu (kucing tidak perlu sering mandi)\n'
          '• Anjing: 1x per 2-4 minggu tergantung jenis bulu\n\n'
          'Grooming rutin bagus untuk kesehatan kulit & bulu ✨';
    }

    // Gemuk / obesitas / berat
    if (_contains(msg, ['gemuk', 'obesitas', 'berat'])) {
      return 'Tips atasi obesitas:\n'
          '• Kurangi porsi makan\n'
          '• Ganti ke makanan low-calorie\n'
          '• Ajak bermain minimal 30 menit/hari\n'
          '• Rutin timbang berat\n\n'
          'Konsultasikan ke dokter untuk program diet khusus ya 💪';
    }

    // Mata / mata merah
    if (_contains(msg, ['mata', 'mata merah'])) {
      return 'Mata merah bisa karena infeksi, alergi, atau debu. Saran:\n'
          '• Bersihkan dengan air bersih\n'
          '• Jangan kasih obat sembarangan\n'
          '• Segera ke dokter kalau berlanjut > 1 hari\n\n'
          'Klik menu Klinik untuk booking ya 👁️';
    }

    // Muntah / diare / pusing
    if (_contains(msg, ['muntah', 'diare', 'pusing'])) {
      return 'Kalau anabul muntah/diare:\n'
          '• Puasakan 6-12 jam (tetap beri air)\n'
          '• Beri makanan ringan setelahnya\n'
          '• Kalau berlanjut > 1 hari atau ada darah → SEGERA ke klinik 🏥';
    }

    // Terima kasih
    if (_contains(msg, ['terima kasih', 'makasih', 'thanks', 'thank you'])) {
      return 'Sama-sama! 🐾 Semoga anabulmu sehat selalu. Kalau ada pertanyaan lain, tanya aja ya!';
    }

    // Identitas bot
    if (_contains(msg, ['nama', 'siapa kamu'])) {
      return 'Aku PetBot, asisten virtual PetCare. Aku bisa bantu jawab pertanyaan seputar kesehatan & perawatan anabul! 🐶🐱';
    }

    // Default — tidak dikenali
    return 'Maaf, aku belum paham pertanyaan itu. Coba tanya dengan kata kunci lain seperti: '
        'vaksin, makanan, sakit, kutu, mandi, atau mata. '
        'Kalau butuh pemeriksaan langsung, kamu bisa booking di salah satu dari 6 cabang PetCare ya 🏥';
  }

  /// Helper: mengecek apakah [message] mengandung salah satu dari [keywords].
  static bool _contains(String message, List<String> keywords) {
    return keywords.any((keyword) => message.contains(keyword));
  }
}
