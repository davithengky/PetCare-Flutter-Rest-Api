/// Model data pengguna (User) aplikasi PetCare.
class User {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String membershipTier;
  final String? photoUrl;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.membershipTier = 'basic',
    this.photoUrl,
  });

  /// Membuat instance User dari Map JSON.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      membershipTier: (json['membership_tier'] as String?) ?? 'basic',
      photoUrl: json['photo_url'] as String?,
    );
  }

  /// Mengonversi instance User ke Map JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'membership_tier': membershipTier,
      'photo_url': photoUrl,
    };
  }

  /// Membuat salinan instance User dengan nilai baru jika disediakan.
  User copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? address,
    String? membershipTier,
    String? photoUrl,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      membershipTier: membershipTier ?? this.membershipTier,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, membershipTier: $membershipTier)';
  }
}
