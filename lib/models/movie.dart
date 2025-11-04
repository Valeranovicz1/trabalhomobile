import 'package:cloud_firestore/cloud_firestore.dart';

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

  factory Movie.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return Movie(
      movie_id: data['movie_id'] ?? 0,
      title: data['title'] ?? 'Título Desconhecido',
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      year: data['year'] ?? 0,
      director: data['director'] ?? '',
      averageRating: (data['averageRating'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'movie_id': movie_id,
      'title': title,
      'imageUrl': imageUrl,
      'description': description,
      'year': year,
      'director': director,
      'averageRating': averageRating,
    };
  }
}
