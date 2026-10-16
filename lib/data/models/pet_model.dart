/// Model data hewan peliharaan (Pet) pada aplikasi PetCare.
class Pet {
  final int id;
  final int userId;
  final String name;
  final String species;
  final String? breed;
  final String gender;
  final int ageMonths;
  final double weightKg;
  final String? photoUrl;

  const Pet({
    required this.id,
    required this.userId,
    required this.name,
    required this.species,
    this.breed,
    required this.gender,
    required this.ageMonths,
    required this.weightKg,
    this.photoUrl,
  });

  /// Membuat instance Pet dari Map JSON.
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      name: json['name'] as String,
      species: json['species'] as String,
      breed: json['breed'] as String?,
      gender: json['gender'] as String,
      ageMonths: json['age_months'] as int,
      weightKg: (json['weight_kg'] as num).toDouble(),
      photoUrl: json['photo_url'] as String?,
    );
  }

  /// Mengonversi instance Pet ke Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'species': species,
      'breed': breed,
      'gender': gender,
      'age_months': ageMonths,
      'weight_kg': weightKg,
      'photo_url': photoUrl,
    };
  }

  /// Membuat salinan instance Pet dengan nilai baru jika disediakan.
  Pet copyWith({
    int? id,
    int? userId,
    String? name,
    String? species,
    String? breed,
    String? gender,
    int? ageMonths,
    double? weightKg,
    String? photoUrl,
  }) {
    return Pet(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      species: species ?? this.species,
      breed: breed ?? this.breed,
      gender: gender ?? this.gender,
      ageMonths: ageMonths ?? this.ageMonths,
      weightKg: weightKg ?? this.weightKg,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'Pet(id: $id, userId: $userId, name: $name, species: $species, breed: $breed, gender: $gender, ageMonths: $ageMonths, weightKg: $weightKg)';
  }
}
