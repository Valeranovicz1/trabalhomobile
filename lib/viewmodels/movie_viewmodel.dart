import 'package:flutter/material.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/repositories/movie_repository.dart';

class MovieViewModel with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;

  List<Movie> get movies => _movies;

  bool get isLoading => _isLoading;

  MovieViewModel() {
    loadMovies();
  }

  Future<void> loadMovies() async {
    _isLoading = true;
    _movies = MovieRepository.movies;
    _isLoading = false;

    notifyListeners();
  }
}
