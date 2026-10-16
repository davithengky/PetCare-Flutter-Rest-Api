// Model untuk adopsi hewan (Adoption)

/// Representasi data hewan siap adopsi.
class Adoption {
  final int id;
  final String name;
  final String species;
  final String age;
  final String description;
  final String contactInfo;
  final String? photoUrl;
  final DateTime createdAt;

  const Adoption({
    required this.id,
    required this.name,
    required this.species,
    required this.age,
    required this.description,
    required this.contactInfo,
    this.photoUrl,
    required this.createdAt,
  });

  /// Factory constructor dari Map/JSON.
  factory Adoption.fromJson(Map<String, dynamic> json) {
    return Adoption(
      id: json['id'] as int,
      name: json['name'] as String,
      species: json['species'] as String,
      age: json['age'] as String,
      description: json['description'] as String,
      contactInfo: json['contact_info'] as String,
      photoUrl: json['photo_url'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Mengonversi Adoption ke Map/JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'species': species,
      'age': age,
      'description': description,
      'contact_info': contactInfo,
      'photo_url': photoUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Salinan Adoption dengan field yang diperbarui.
  Adoption copyWith({
    int? id,
    String? name,
    String? species,
    String? age,
    String? description,
    String? contactInfo,
    String? photoUrl,
    DateTime? createdAt,
  }) {
    return Adoption(
      id: id ?? this.id,
      name: name ?? this.name,
      species: species ?? this.species,
      age: age ?? this.age,
      description: description ?? this.description,
      contactInfo: contactInfo ?? this.contactInfo,
      photoUrl: photoUrl ?? this.photoUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Adoption(id: $id, name: $name, species: $species, age: $age, contactInfo: $contactInfo, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Adoption &&
        other.id == id &&
        other.name == name &&
        other.species == species &&
        other.age == age &&
        other.description == description &&
        other.contactInfo == contactInfo &&
        other.photoUrl == photoUrl &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      species,
      age,
      description,
      contactInfo,
      photoUrl,
      createdAt,
    );
  }
}
