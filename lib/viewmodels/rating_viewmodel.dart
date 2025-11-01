// lib/viewmodels/rating_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:projetomobile/models/rating.dart';
import 'package:projetomobile/repositories/movie_repository.dart';

class RatingViewModel with ChangeNotifier {
  final Map<int, Map<int, Rating>> _userRatings = {};

  final Map<int, double> _movieAverageRatings = {};

  double getMovieAverageRating(int movieId) {
    return _movieAverageRatings[movieId] ?? 0.0;
  }

  void rateMovie({
    required int userId,
    required int movieId,
    required double ratingValue,
  }) {
    if (!_userRatings.containsKey(userId)) {
      _userRatings[userId] = {};
    }

    final currentRating = _userRatings[userId]![movieId]?.value;

    if (currentRating == ratingValue) {
      _userRatings[userId]!.remove(movieId);
    } else {
      _userRatings[userId]![movieId] = Rating(
        userId: userId,
        movieId: movieId,
        value: ratingValue,
      );
    }

    _calculateAverageRating(movieId);
    notifyListeners();
  }

  double getUserRatingForMovie(int userId, int movieId) {
    return _userRatings[userId]?[movieId]?.value ?? 0.0;
  }

  void _calculateAverageRating(int movieId) {
    List<double> ratingsForMovie = [];

    _userRatings.forEach((userId, movieRatings) {
      if (movieRatings.containsKey(movieId)) {
        ratingsForMovie.add(movieRatings[movieId]!.value);
      }
    });

    if (ratingsForMovie.isNotEmpty) {
      final sum = ratingsForMovie.reduce((a, b) => a + b);
      final average = sum / ratingsForMovie.length;
      _movieAverageRatings[movieId] = double.parse(average.toStringAsFixed(1));
      MovieRepository.updateMovieAverageRating(
        movieId,
        _movieAverageRatings[movieId]!,
      );
    } else {
      _movieAverageRatings[movieId] = 0.0;
      MovieRepository.updateMovieAverageRating(movieId, 0.0);
    }
  }
}
