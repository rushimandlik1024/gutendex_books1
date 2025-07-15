
class Book {
  final String title;
  final List<String> authors;
  final String? coverImage;
  final Map<String, dynamic> formats;

  Book({
    required this.title,
    required this.authors,
    required this.coverImage,
    required this.formats,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? '',
      authors: (json['authors'] as List)
          .map((a) => a['name'] as String)
          .toList(),
      coverImage: json['formats']['image/jpeg'],
      formats: json['formats'],
    );
  }
}
