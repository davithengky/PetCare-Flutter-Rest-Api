/// Model data untuk cabang klinik hewan PetCare Vet Clinic.
class Clinic {
  final int id;
  final String name;
  final String branchName;
  final String address;
  final String city;
  final String phone;
  final String operatingHours;
  final double? latitude;
  final double? longitude;
  final List<String> services;
  final double rating;
  final String? photoUrl;

  const Clinic({
    required this.id,
    required this.name,
    required this.branchName,
    required this.address,
    required this.city,
    required this.phone,
    required this.operatingHours,
    this.latitude,
    this.longitude,
    required this.services,
    required this.rating,
    this.photoUrl,
  });

  /// Nama tampilan gabungan brand dan nama cabang (contoh: "PetCare Vet Clinic — Cabang Darmo").
  String get displayName => '$name — $branchName';

  /// Membuat instance [Clinic] dari JSON map.
  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] as int,
      name: json['name'] as String,
      branchName: json['branch_name'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      phone: json['phone'] as String,
      operatingHours: json['operating_hours'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      services: (json['services'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
      rating: (json['rating'] as num).toDouble(),
      photoUrl: json['photo_url'] as String?,
    );
  }

  /// Mengonversi instance [Clinic] ke JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'branch_name': branchName,
      'address': address,
      'city': city,
      'phone': phone,
      'operating_hours': operatingHours,
      'latitude': latitude,
      'longitude': longitude,
      'services': services,
      'rating': rating,
      'photo_url': photoUrl,
    };
  }

  /// Membuat salinan objek dengan nilai baru yang opsional.
  Clinic copyWith({
    int? id,
    String? name,
    String? branchName,
    String? address,
    String? city,
    String? phone,
    String? operatingHours,
    double? latitude,
    double? longitude,
    List<String>? services,
    double? rating,
    String? photoUrl,
  }) {
    return Clinic(
      id: id ?? this.id,
      name: name ?? this.name,
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      city: city ?? this.city,
      phone: phone ?? this.phone,
      operatingHours: operatingHours ?? this.operatingHours,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      services: services ?? this.services,
      rating: rating ?? this.rating,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'Clinic(id: $id, name: $name, branchName: $branchName, address: $address, city: $city, phone: $phone, operatingHours: $operatingHours, latitude: $latitude, longitude: $longitude, services: $services, rating: $rating, photoUrl: $photoUrl)';
  }
}
