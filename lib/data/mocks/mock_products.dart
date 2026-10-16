import '../models/product_model.dart';

/// Data mock 20 produk katalog Pet Shop PetCare Vet Clinic.
final List<Product> mockProducts = [
  // ===================== MAKANAN (6 Produk) =====================
  const Product(
    id: 1,
    name: 'Royal Canin Maxi Adult 4kg',
    category: 'Makanan',
    price: 285000,
    originalPrice: 325000,
    stock: 25,
    description:
        'Makanan kering bernutrisi seimbang untuk anjing dewasa ras besar (26-44 kg). Membantu menjaga kesehatan tulang, sendi, dan daya cerna optimal.',
    imageUrl:
        'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=600&auto=format&fit=crop',
    rating: 4.9,
    soldCount: 250,
  ),
  const Product(
    id: 2,
    name: 'Whiskas Tuna 1.2kg',
    category: 'Makanan',
    price: 85000,
    originalPrice: null,
    stock: 50,
    description:
        'Makanan kering kucing dengan rasa tuna lezat yang diperkaya vitamin dan mineral esensial untuk bulu berkilau dan energi anabul aktif.',
    imageUrl:
        'https://images.unsplash.com/photo-1590769383363-5681e57ff10f?w=600&q=80&fit=crop',
    rating: 4.7,
    soldCount: 500,
  ),
  const Product(
    id: 3,
    name: 'Pedigree Puppy 3kg',
    category: 'Makanan',
    price: 165000,
    originalPrice: 195000,
    stock: 30,
    description:
        'Formula khusus untuk anak anjing dalam masa pertumbuhan. Mengandung DHA, kalsium, dan fosfor untuk mendukung pertumbuhan gigi dan tulang kuat.',
    imageUrl:
        'https://images.unsplash.com/photo-1568640347023-a616a30bc3bd?w=600&auto=format&fit=crop',
    rating: 4.8,
    soldCount: 180,
  ),
  const Product(
    id: 4,
    name: 'Me-O Cat Food Salmon 1kg',
    category: 'Makanan',
    price: 65000,
    originalPrice: null,
    stock: 40,
    description:
        'Makanan kucing dengan rasa salmon segar bernutrisi tinggi, mengandung taurin untuk kesehatan penglihatan dan vitamin C untuk kekebalan tubuh.',
    imageUrl:
        'https://images.unsplash.com/photo-1558993457-4bc6ec2c3734?w=600&q=80&fit=crop',
    rating: 4.6,
    soldCount: 320,
  ),
  const Product(
    id: 5,
    name: 'Pro Plan Kitten 1.5kg',
    category: 'Makanan',
    price: 210000,
    originalPrice: null,
    stock: 20,
    description:
        'Makanan super premium untuk anak kucing (1-12 bulan) dengan kolostrum untuk memperkuat sistem imun alami dan perlindungan saluran cerna.',
    imageUrl:
        'https://images.unsplash.com/photo-1764576504536-dbdfa4cb1d9a?w=600&q=80&fit=crop',
    rating: 4.9,
    soldCount: 120,
  ),
  const Product(
    id: 6,
    name: 'Alpo Adult Beef 2kg',
    category: 'Makanan',
    price: 145000,
    originalPrice: null,
    stock: 35,
    description:
        'Makanan anjing dewasa dengan cita rasa daging sapi lezat. Diperkaya protein hewani untuk otot kuat dan zat besi untuk darah sehat.',
    imageUrl:
        'https://images.unsplash.com/photo-1676193866128-03a926df76ef?w=600&q=80&fit=crop',
    rating: 4.5,
    soldCount: 200,
  ),

  // ===================== OBAT & PERAWATAN (5 Produk) =====================
  const Product(
    id: 7,
    name: 'Frontline Plus Spot On (Kucing)',
    category: 'Obat',
    price: 180000,
    originalPrice: null,
    stock: 30,
    description:
        'Obat tetes kutu ampuh untuk kucing yang membasmi kutu pinjal, caplak, dan telurnya selama 30 hari perlindungan penuh.',
    imageUrl:
        'https://images.unsplash.com/photo-1787771206780-2c527ff20306?w=600&q=80&fit=crop',
    rating: 4.8,
    soldCount: 150,
  ),
  const Product(
    id: 8,
    name: 'Obat Cacing Drontal Cat',
    category: 'Obat',
    price: 45000,
    originalPrice: null,
    stock: 60,
    description:
        'Tablet obat cacing spektrum luas untuk kucing dewasa dan anak kucing. Efektif mengeliminasi cacing gelang, cacing tambang, dan cacing pita.',
    imageUrl:
        'https://images.unsplash.com/photo-1630094539416-5e17c6191be5?w=600&q=80&fit=crop',
    rating: 4.7,
    soldCount: 400,
  ),
  const Product(
    id: 9,
    name: 'Vitamin Kucing Nutri Plus',
    category: 'Obat',
    price: 55000,
    originalPrice: null,
    stock: 45,
    description:
        'Gel multivitamin dan mineral berenergi tinggi untuk merangsang nafsu makan dan mempercepat pemulihan anabul pasca sakit.',
    imageUrl:
        'https://images.unsplash.com/photo-1606235357537-84aea24d4c4f?w=600&q=80&fit=crop',
    rating: 4.6,
    soldCount: 280,
  ),
  const Product(
    id: 10,
    name: 'Salep Mata Anjing Vetmedin',
    category: 'Obat',
    price: 85000,
    originalPrice: null,
    stock: 25,
    description:
        'Salep antibiotik topikal untuk mengatasi radang, infeksi bakteri, dan iritasi pada mata anjing peliharaan.',
    imageUrl:
        'https://images.unsplash.com/photo-1750125625145-7be950011e4c?w=600&q=80&fit=crop',
    rating: 4.5,
    soldCount: 90,
  ),
  const Product(
    id: 11,
    name: 'Shampoo Anti Kutu Anjing',
    category: 'Obat',
    price: 95000,
    originalPrice: 115000,
    stock: 35,
    description:
        'Shampoo pembersih bulu dengan formula antiparasit alami yang mengusir kutu, meredakan gatal, dan membuat bulu wangi tahan lama.',
    imageUrl:
        'https://images.unsplash.com/photo-1516734212186-a967f81ad0d7?w=600&auto=format&fit=crop',
    rating: 4.8,
    soldCount: 220,
  ),

  // ===================== MAINAN (5 Produk) =====================
  const Product(
    id: 12,
    name: 'Bola Karet Anjing Chew Toy',
    category: 'Mainan',
    price: 45000,
    originalPrice: null,
    stock: 50,
    description:
        'Bola gigitan dari karet non-toxic yang elastis dan tahan gigitan kuat. Membantu membersihkan plak gigi saat anabul bermain.',
    imageUrl:
        'https://images.unsplash.com/photo-1768058430062-9e8309e7e665?w=600&auto=format&fit=crop',
    rating: 4.7,
    soldCount: 350,
  ),
  const Product(
    id: 13,
    name: 'Tongkat Bulu Kucing Interaktif',
    category: 'Mainan',
    price: 35000,
    originalPrice: null,
    stock: 70,
    description:
        'Mainan pancingan bulu warna-warni dengan lonceng kecil yang melatih ketangkasan berburu dan membuat kucing aktif bergerak ceria.',
    imageUrl:
        'https://images.unsplash.com/photo-1718975463952-a7ca7d2c7daf?w=600&q=80&fit=crop',
    rating: 4.9,
    soldCount: 600,
  ),
  const Product(
    id: 14,
    name: 'Laser Pointer Cat Toy',
    category: 'Mainan',
    price: 55000,
    originalPrice: null,
    stock: 40,
    description:
        'Lampu laser LED merah aman untuk mata dengan mode multi-motif untuk mengajak kucing berlari dan melompat aktif di dalam rumah.',
    imageUrl:
        'https://images.unsplash.com/photo-1740965683843-57af52f46456?w=600&q=80&fit=crop',
    rating: 4.8,
    soldCount: 420,
  ),
  const Product(
    id: 15,
    name: 'Tikus Mainan Kucing',
    category: 'Mainan',
    price: 25000,
    originalPrice: null,
    stock: 80,
    description:
        'Mainan boneka tikus berbulu halus dilengkapi serbuk catnip organik yang sangat disukai dan memancing rasa penasaran kucing.',
    imageUrl:
        'https://images.unsplash.com/photo-1768042230944-885b8c1482a2?w=600&q=80&fit=crop',
    rating: 4.5,
    soldCount: 500,
  ),
  const Product(
    id: 16,
    name: 'Ring Donat Gigitan Anjing',
    category: 'Mainan',
    price: 65000,
    originalPrice: null,
    stock: 30,
    description:
        'Mainan gigit berbentuk donat dengan tekstur bergerigi untuk memijat gusi anak anjing dan melatih kekuatan rahang.',
    imageUrl:
        'https://images.unsplash.com/photo-1786945999064-864a85b81765?w=600&q=80&fit=crop',
    rating: 4.6,
    soldCount: 180,
  ),

  // ===================== AKSESORIS (4 Produk) =====================
  const Product(
    id: 17,
    name: 'Kalung Kucing Lonceng',
    category: 'Aksesoris',
    price: 35000,
    originalPrice: null,
    stock: 65,
    description:
        'Kalung leher bahan nilon lembut yang bisa disesuaikan ukurannya, dilengkapi lonceng gemerincing imut dan gesper pengaman pelepas cepat.',
    imageUrl:
        'https://images.unsplash.com/photo-1546180572-28e937c8128b?w=600&q=80&fit=crop',
    rating: 4.7,
    soldCount: 300,
  ),
  const Product(
    id: 18,
    name: 'Tempat Makan Stainless 2in1',
    category: 'Aksesoris',
    price: 85000,
    originalPrice: 105000,
    stock: 40,
    description:
        'Mangkuk ganda untuk makanan dan minuman dari stainless steel anti karat dengan alas karet anti selip di bawahnya.',
    imageUrl:
        'https://images.unsplash.com/photo-1708105612115-36a658231987?w=600&q=80&fit=crop',
    rating: 4.8,
    soldCount: 250,
  ),
  const Product(
    id: 19,
    name: 'Kandang Kucing Medium',
    category: 'Aksesoris',
    price: 450000,
    originalPrice: null,
    stock: 15,
    description:
        'Kandang besi lipat kokoh ukuran 60x45x50 cm dilapisi cat anti karat dengan tatakan plastik bawah yang mudah dibersihkan.',
    imageUrl:
        'https://images.unsplash.com/photo-1649002944575-1297b11c9a1c?w=600&q=80&fit=crop',
    rating: 4.6,
    soldCount: 60,
  ),
  const Product(
    id: 20,
    name: 'Tas Gendong Anjing',
    category: 'Aksesoris',
    price: 195000,
    originalPrice: null,
    stock: 20,
    description:
        'Tas ransel pet carrier dengan ventilasi jaring bernapas dan tali pengait kerah untuk membawa anabul jalan-jalan dengan aman dan nyaman.',
    imageUrl:
        'https://images.unsplash.com/photo-1765045952615-9e28d239f053?w=600&q=80&fit=crop',
    rating: 4.7,
    soldCount: 120,
  ),
];
