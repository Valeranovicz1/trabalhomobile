class Movie {
  final int movie_id;
  final String title;
  final String imageUrl;
  final String description;
  final int year;
  final String director;
  double averageRating;

  Movie({
    required this.movie_id,
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.year,
    required this.director,
    this.averageRating = 0.0,
  });
}
