import 'package:flutter/material.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MovieViewModel with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = true;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;

  MovieViewModel() {
    loadMovies();
  }

  Future<void> loadMovies() async {
    try {
      QuerySnapshot movieSnapshot = await FirebaseFirestore.instance
          .collection('movies')
          .get();
      _movies = movieSnapshot.docs.map((doc) {
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
      }).toList();
    } catch (e) {
      _movies = [];
    }
    _isLoading = false;
    notifyListeners();
  }
}
