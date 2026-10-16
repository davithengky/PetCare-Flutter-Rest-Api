import '../models/adoption_model.dart';

/// Data mock program adopsi hewan PetCare.
final List<Adoption> mockAdoptions = [
  Adoption(
    id: 1,
    name: 'Milo',
    species: 'Kucing',
    age: '5 bulan',
    description:
        'Milo adalah anak kucing domestik yang sangat ramah dan gemar mendengkur. Sudah tuntas obat cacing dan vaksin pertama, mencari orang tua asuh penyayang.',
    contactInfo: '0812-3456-7890',
    photoUrl:
        'https://images.pexels.com/photos/34719941/pexels-photo-34719941.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
  ),
  Adoption(
    id: 2,
    name: 'Luna',
    species: 'Kucing',
    age: '1 tahun',
    description:
        'Luna berbulu abu-abu lembut dengan sifat yang tenang dan anggun. Sangat cocok untuk penghuni apartemen karena tidak berisik dan terbiasa litter box.',
    contactInfo: '0812-9876-5432',
    photoUrl:
        'https://images.pexels.com/photos/13473569/pexels-photo-13473569.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 3)),
  ),
  Adoption(
    id: 3,
    name: 'Rocky',
    species: 'Anjing',
    age: '8 bulan',
    description:
        'Rocky merupakan anjing campuran berenergi tinggi yang suka diajak jalan sore. Pintar, patuh, dan sudah bisa perintah duduk serta salaman.',
    contactInfo: '0812-2345-6789',
    photoUrl:
        'https://images.pexels.com/photos/38306667/pexels-photo-38306667.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 4)),
  ),
  Adoption(
    id: 4,
    name: 'Bella',
    species: 'Anjing',
    age: '1.5 tahun',
    description:
        'Bella anjing betina yang sangat manis dan setia. Penyayang anak kecil, sudah disteril dan sehat bebas parasit kulit.',
    contactInfo: '0812-8765-4321',
    photoUrl:
        'https://images.pexels.com/photos/32949053/pexels-photo-32949053.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 6)),
  ),
  Adoption(
    id: 5,
    name: 'Cimol',
    species: 'Kucing',
    age: '3 bulan',
    description:
        'Kitten putih bersih lucu dan suka bermain bola lonceng. Sangat lincah dan sehat, siap diadopsi bersama saudaranya atau mandiri.',
    contactInfo: '0812-1122-3344',
    photoUrl:
        'https://images.pexels.com/photos/6900232/pexels-photo-6900232.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 8)),
  ),
  Adoption(
    id: 6,
    name: 'Oyen',
    species: 'Kucing',
    age: '2 tahun',
    description:
        'Kucing jantan oranye bertubuh gembul yang suka tidur di pangkuan. Sangat jinak, sudah steril dan vaksin rabies lengkap.',
    contactInfo: '0812-5566-7788',
    photoUrl:
        'https://images.pexels.com/photos/29020872/pexels-photo-29020872.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 10)),
  ),
  Adoption(
    id: 7,
    name: 'Bruno',
    species: 'Anjing',
    age: '2 tahun',
    description:
        'Bruno penjaga setia yang penyayang. Tubuh tegap dan lincah, sangat responsif terhadap arahan pemilik dan ramah terhadap anjing lain.',
    contactInfo: '0812-9988-7766',
    photoUrl:
        'https://images.pexels.com/photos/144608/pexels-photo-144608.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 12)),
  ),
  Adoption(
    id: 8,
    name: 'Kiki',
    species: 'Kucing',
    age: '7 bulan',
    description:
        'Kiki adalah kucing tortoiseshell manis dengan mata bulat bersinar. Suka diajak bicara dan selalu menyambut pemilik di depan pintu rumah.',
    contactInfo: '0812-4433-2211',
    photoUrl:
        'https://images.pexels.com/photos/35765211/pexels-photo-35765211.jpeg?auto=compress&cs=tinysrgb&w=600',
    createdAt: DateTime.now().subtract(const Duration(days: 15)),
  ),
];
