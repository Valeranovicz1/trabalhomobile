class Movie {
  final int id;
  final String title;
  final String imageUrl;
  final String description;
  final int year;
  final String director;
  double averageRating;

  Movie({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.year,
    required this.director,
    this.averageRating = 0.0,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? json['id'] ?? 0,
      title: json['title'] ?? 'Sem Título',
      imageUrl: json['imageUrl'] ?? '',
      description: json['description'] ?? '',
      year: json['year'] ?? 0,
      director: json['director'] ?? '',
      averageRating: 0.0,
    );
  }
}
