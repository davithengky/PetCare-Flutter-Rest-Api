import '../models/article_model.dart';

/// Data mock artikel edukasi perawatan hewan (Pet Care Tips).
final List<Article> mockArticles = [
  Article(
    id: 1,
    title: '5 Makanan Sehat untuk Kucing Peliharaan',
    category: 'Makanan',
    content:
        'Kucing membutuhkan nutrisi seimbang yang kaya akan protein hewani untuk menjaga kesehatan tubuh dan bulunya. Makanan basah (wet food) berkualitas tinggi sangat baik untuk menjaga hidrasi ginjal anabul.\n\nSelain itu, pastikan makanan kucing mengandung asam amino esensial seperti taurin yang tidak bisa diproduksi sendiri oleh tubuh kucing. Kekurangan taurin dapat memicu gangguan penglihatan dan masalah jantung.\n\nHindari memberikan makanan manusia seperti cokelat, bawang, atau susu sapi tinggi laktosa yang dapat memicu diare serta keracunan pencernaan.',
    coverUrl:
        'https://images.pexels.com/photos/13473569/pexels-photo-13473569.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'drh. Anisa Rahma',
    readTimeMinutes: 5,
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
  ),
  Article(
    id: 2,
    title: 'Panduan Memberi Makan Anjing Sesuai Usia',
    category: 'Makanan',
    content:
        'Kebutuhan gizi anjing berubah drastis seiring bertambahnya usia. Puppy membutuhkan porsi kalori dan kalsium lebih banyak untuk mendukung pertumbuhan tulang dan otot yang cepat.\n\nSaat memasuki usia dewasa, fokus pakan beralih ke pemeliharaan berat badan ideal dan daya tahan tubuh aktif. Berikan porsi teratur 2 kali sehari agar terhindar dari obesitas.\n\nUntuk anjing senior, pilih makanan rendah kalori namun diperkaya glukosamin dan omega-3 guna merawat kelenturan persendian serta fungsi ginjal.',
    coverUrl:
        'https://images.pexels.com/photos/34418146/pexels-photo-34418146.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'drh. Budi Prasetyo',
    readTimeMinutes: 7,
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Article(
    id: 3,
    title: 'Cara Memandikan Kucing yang Benar',
    category: 'Perawatan',
    content:
        'Sebagian besar kucing enggan terkena air, sehingga proses memandikan harus dilakukan dengan tenang dan perlahan. Gunakan air hangat suam-suam kuku agar kucing merasa relaks dan tidak kedinginan.\n\nGunakan sampo khusus kucing, hindari sampo manusia karena pH kulit kucing jauh berbeda dan bisa menimbulkan iritasi kulit parah. Mulailah menyiram dari tubuh bagian belakang secara bertahap.\n\nKeringkan bulu dengan handuk bersih lalu gunakan hair dryer berkecepatan rendah dan bersuara halus. Jangan lupa beri camilan (treats) setelah selesai sebagai apresiasi.',
    coverUrl:
        'https://images.pexels.com/photos/6131005/pexels-photo-6131005.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'Tim PetCare',
    readTimeMinutes: 4,
    createdAt: DateTime.now().subtract(const Duration(days: 2)),
  ),
  Article(
    id: 4,
    title: 'Jadwal Grooming Ideal untuk Anjing',
    category: 'Perawatan',
    content:
        'Grooming rutin bukan hanya soal estetika, melainkan langkah penting menjaga kesehatan kulit, kuku, dan telinga anjing kesayangan Anda. Mandi disarankan setiap 2-4 minggu sekali tergantung jenis bulu dan aktivitas luar ruangan.\n\nMenyisir bulu harus dilakukan lebih sering, terutama untuk ras berbulu lebat seperti Golden Retriever atau Shih Tzu guna mencegah gimbal (matted fur) yang memicu sarang jamur.\n\nJangan abaikan pemotongan kuku setiap 3-4 minggu dan pembersihan daun telinga mingguan dengan cairan pembersih khusus veteriner.',
    coverUrl:
        'https://images.pexels.com/photos/19145894/pexels-photo-19145894.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'Tim PetCare',
    readTimeMinutes: 6,
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Article(
    id: 5,
    title: 'Merawat Bulu Kucing Agar Tidak Rontok',
    category: 'Perawatan',
    content:
        'Kerontokan bulu kucing bisa disebabkan oleh faktor alami pergantian bulu, alergi makanan, atau infeksi parasit kulit. Sisir bulu anabul setiap hari untuk mengangkat bulu mati dan merangsang sirkulasi darah.\n\nSuplemen minyak ikan kaya asam lemak Omega-3 dan Omega-6 terbukti efektif memperkuat akar bulu dan membuat mantel bulu tampak berkilau lebat.\n\nJika kerontokan disertai pitak kemerahan atau kucing terus menggaruk, segera bawa ke dokter hewan di klinik PetCare terdekat untuk pemeriksaan jamur atau kutu.',
    coverUrl:
        'https://images.pexels.com/photos/29020872/pexels-photo-29020872.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'drh. Citra Dewi',
    readTimeMinutes: 5,
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  Article(
    id: 6,
    title: 'Kenali Gejala Penyakit Kulit pada Anjing',
    category: 'Penyakit',
    content:
        'Penyakit kulit atau dermatitis adalah keluhan paling sering pada anjing. Gejala awal meliputi sering menggaruk satu area tubuh, menjilat kaki berlebihan, dan muncul bau tidak sedap dari kulit.\n\nPenyebab umum antara lain kutu (flea allergy), infeksi jamur ringworm, atau alergi pakan berbahan dasar protein tertentu. Area yang teriritasi biasanya memerah dan bulu rontok.\n\nPenanganan medis tepat waktu dengan salep antibiotik, sampo medikasi, atau injeksi anti-gatal sangat penting agar infeksi sekunder tidak menyebar ke seluruh tubuh.',
    coverUrl:
        'https://images.pexels.com/photos/32949053/pexels-photo-32949053.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'drh. Dani Kusuma',
    readTimeMinutes: 8,
    createdAt: DateTime.now().subtract(const Duration(days: 5)),
  ),
  Article(
    id: 7,
    title: 'Bahaya Cacing pada Kucing & Cara Mengatasinya',
    category: 'Penyakit',
    content:
        'Cacingan dapat menyerang kucing segala usia, terutama kitten yang tertular dari air susu induknya. Gejala yang tampak antara lain perut buncit namun badan kurus, muntah, serta bulu kusam.\n\nCacing gelang dan cacing pita dapat menyerap sari makanan secara masif dan berisiko menyebabkan anemia berat pada anak kucing.\n\nPemberian obat cacing rutin setiap 3 bulan sekali adalah perlindungan terbaik. Pastikan dosis obat disesuaikan dengan berat badan kucing Anda melalui konsultasi dokter hewan.',
    coverUrl:
        'https://images.pexels.com/photos/8434635/pexels-photo-8434635.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'drh. Anisa Rahma',
    readTimeMinutes: 6,
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
  Article(
    id: 8,
    title: 'Vaksin Wajib untuk Anak Kucing',
    category: 'Penyakit',
    content:
        'Vaksinasi adalah benteng pertahanan utama anak kucing dari virus mematikan seperti Panleukopenia, Calicivirus, dan Rhinotracheitis (Feline Viral Rhinotracheitis).\n\nProgram vaksin pertama dimulai pada usia 6-8 minggu dengan vaksin Tricat, dilanjutkan booster 3-4 minggu kemudian, serta vaksin rabies saat usia minimal 3 bulan.\n\nPastikan kitten dalam kondisi prima tanpa demam atau flu sebelum divaksinasi agar pembentukan antibodi berlangsung optimal.',
    coverUrl:
        'https://images.pexels.com/photos/6900232/pexels-photo-6900232.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'drh. Budi Prasetyo',
    readTimeMinutes: 5,
    createdAt: DateTime.now().subtract(const Duration(days: 7)),
  ),
  Article(
    id: 9,
    title: 'Mengapa Kucing Suka Menggaruk Sofa?',
    category: 'Perilaku',
    content:
        'Menggaruk adalah naluri alami kucing untuk menandai wilayah kekuasaan dengan kelenjar aroma di telapak kakinya, sekaligus mengasah kuku dan meregangkan otot bahu.\n\nJika sofa Anda menjadi korban, solusinya bukan memarahi anabul, melainkan menyediakan media garuk (scratching post) yang kokoh dan ditempatkan tepat di dekat perabotan favoritnya.\n\nOleskan sedikit catnip di tiang garukan baru dan tutupi sisi sofa dengan pelindung sementara agar kucing terbiasa mengalihkan kebiasaannya.',
    coverUrl:
        'https://images.pexels.com/photos/35765211/pexels-photo-35765211.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'Tim PetCare',
    readTimeMinutes: 4,
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Article(
    id: 10,
    title: '10 Tips Membuat Anabul Betah di Rumah',
    category: 'Tips',
    content:
        'Menciptakan lingkungan ramah hewan peliharaan membutuhkan perhatian pada keamanan fisik dan stimulasi mental. Sediakan area istirahat yang hangat, tenang, dan jauh dari lalu-lalang bising.\n\nBerikan mainan interaktif seperti puzzle feeder dan bola untuk mengasah insting berburu mereka. Rutin luangkan waktu 15-30 menit sehari untuk bermain dan berinteraksi secara konsisten.\n\nPastikan tempat buang air (litter box/pee pad) selalu dibersihkan setiap hari serta jauh dari mangkuk makan agar anabul merasa nyaman dan bebas stres.',
    coverUrl:
        'https://images.pexels.com/photos/16299046/pexels-photo-16299046.jpeg?auto=compress&cs=tinysrgb&w=600',
    author: 'Tim PetCare',
    readTimeMinutes: 5,
    createdAt: DateTime.now().subtract(const Duration(days: 9)),
  ),
];
