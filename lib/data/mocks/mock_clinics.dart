import '../models/clinic_model.dart';

/// Data mock 6 cabang resmi PetCare Vet Clinic di area Surabaya & sekitarnya.
final List<Clinic> mockClinics = [
  const Clinic(
    id: 1,
    name: 'PetCare Vet Clinic',
    branchName: 'Cabang Darmo',
    address: 'Jl. Raya Darmo No. 88',
    city: 'Surabaya',
    phone: '031-5671234',
    operatingHours: '08:00 - 21:00',
    latitude: null,
    longitude: null,
    services: ['consultation', 'grooming', 'vaccination'],
    rating: 4.9,
    photoUrl:
        'https://images.pexels.com/photos/6235020/pexels-photo-6235020.jpeg?auto=compress&cs=tinysrgb&w=600',
  ),
  const Clinic(
    id: 2,
    name: 'PetCare Vet Clinic',
    branchName: 'Cabang Gubeng',
    address: 'Jl. Gubeng Airlangga No. 45',
    city: 'Surabaya',
    phone: '031-5012345',
    operatingHours: '08:00 - 20:00',
    services: ['consultation', 'grooming', 'vaccination'],
    rating: 4.7,
    photoUrl:
        'https://images.pexels.com/photos/7469231/pexels-photo-7469231.jpeg?auto=compress&cs=tinysrgb&w=600',
  ),
  const Clinic(
    id: 3,
    name: 'PetCare Vet Clinic',
    branchName: 'Cabang Merr',
    address: 'Jl. Dr. Ir. H. Soekarno No. 120',
    city: 'Surabaya',
    phone: '031-5923456',
    operatingHours: '09:00 - 21:00',
    services: ['consultation', 'grooming'],
    rating: 4.8,
    photoUrl:
        'https://images.pexels.com/photos/33394245/pexels-photo-33394245.jpeg?auto=compress&cs=tinysrgb&w=600',
  ),
  const Clinic(
    id: 4,
    name: 'PetCare Vet Clinic',
    branchName: 'Cabang Sidoarjo',
    address: 'Jl. Ahmad Yani No. 55',
    city: 'Sidoarjo',
    phone: '031-8901234',
    operatingHours: '08:00 - 20:00',
    services: ['consultation', 'grooming', 'vaccination'],
    rating: 4.6,
    photoUrl:
        'https://images.pexels.com/photos/38587869/pexels-photo-38587869.jpeg?auto=compress&cs=tinysrgb&w=600',
  ),
  const Clinic(
    id: 5,
    name: 'PetCare Vet Clinic',
    branchName: 'Cabang Gresik',
    address: 'Jl. Veteran No. 32',
    city: 'Gresik',
    phone: '031-3987654',
    operatingHours: '08:00 - 19:00',
    services: ['consultation', 'vaccination'],
    rating: 4.5,
    photoUrl:
        'https://images.pexels.com/photos/7800666/pexels-photo-7800666.jpeg?auto=compress&cs=tinysrgb&w=600',
  ),
  const Clinic(
    id: 6,
    name: 'PetCare Vet Clinic',
    branchName: 'Cabang Rungkut',
    address: 'Jl. Rungkut Industri No. 18',
    city: 'Surabaya',
    phone: '031-8712345',
    operatingHours: '08:00 - 21:00',
    services: ['consultation', 'grooming', 'vaccination'],
    rating: 4.9,
    photoUrl:
        'https://images.pexels.com/photos/7474550/pexels-photo-7474550.jpeg?auto=compress&cs=tinysrgb&w=600',
  ),
];
