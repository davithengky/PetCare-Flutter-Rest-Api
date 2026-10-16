// Model untuk artikel edukasi perawatan hewan (Article)

/// Representasi artikel pet care tips dan edukasi.
class Article {
  final int id;
  final String title;
  final String category; // 'Makanan' | 'Perawatan' | 'Penyakit' | 'Perilaku' | 'Tips'
  final String content;
  final String? coverUrl;
  final String author;
  final int readTimeMinutes;
  final DateTime createdAt;

  const Article({
    required this.id,
    required this.title,
    required this.category,
    required this.content,
    this.coverUrl,
    required this.author,
    required this.readTimeMinutes,
    required this.createdAt,
  });

  /// Factory constructor dari Map/JSON.
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int,
      title: json['title'] as String,
      category: json['category'] as String,
      content: json['content'] as String,
      coverUrl: json['cover_url'] as String?,
      author: json['author'] as String,
      readTimeMinutes: json['read_time_minutes'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  /// Mengonversi Article ke Map/JSON.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'content': content,
      'cover_url': coverUrl,
      'author': author,
      'read_time_minutes': readTimeMinutes,
      'created_at': createdAt.toIso8601String(),
    };
  }

  /// Membuat salinan Article dengan nilai yang diperbarui.
  Article copyWith({
    int? id,
    String? title,
    String? category,
    String? content,
    String? coverUrl,
    String? author,
    int? readTimeMinutes,
    DateTime? createdAt,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      content: content ?? this.content,
      coverUrl: coverUrl ?? this.coverUrl,
      author: author ?? this.author,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Article(id: $id, title: $title, category: $category, author: $author, readTimeMinutes: $readTimeMinutes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Article &&
        other.id == id &&
        other.title == title &&
        other.category == category &&
        other.content == content &&
        other.coverUrl == coverUrl &&
        other.author == author &&
        other.readTimeMinutes == readTimeMinutes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      title,
      category,
      content,
      coverUrl,
      author,
      readTimeMinutes,
      createdAt,
    );
  }
}
