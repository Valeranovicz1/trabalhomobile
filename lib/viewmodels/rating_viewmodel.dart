import 'package:flutter/material.dart';
import 'package:projetomobile/models/rating.dart';
import 'package:projetomobile/services/api_service.dart';

class RatingViewModel with ChangeNotifier {
  final ApiService _api = ApiService();

  final Map<int, List<Rating>> _movieReviewsCache = {};
  final Map<int, double> _movieAverageRatings = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<Rating> getReviewsForMovie(int movieId) {
    return _movieReviewsCache[movieId] ?? [];
  }

  double getMovieAverageRating(int movieId) {
    return _movieAverageRatings[movieId] ?? 0.0;
  }

  Rating? getUserReviewForMovie(String userId, int movieId) {
    final reviews = _movieReviewsCache[movieId];
    if (reviews == null) return null;
    try {
      return reviews.firstWhere(
        (r) => r.userId.toString() == userId.toString(),
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> fetchReviewsForMovie(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final ratings = await _api.getRatings(movieId);

      _movieReviewsCache[movieId] = ratings;

      _recalculateAverage(movieId);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchRatingsForMovieList(List<dynamic> movies) async {
    for (var movie in movies) {
      try {
        int movieId = movie.id;

        final ratings = await _api.getRatings(movieId);
        _movieReviewsCache[movieId] = ratings;

        if (ratings.isNotEmpty) {
          final sum = ratings.map((r) => r.value).reduce((a, b) => a + b);
          final average = sum / ratings.length;
          _movieAverageRatings[movieId] = double.parse(
            average.toStringAsFixed(1),
          );
        } else {
          _movieAverageRatings[movieId] = 0.0;
        }
      } catch (e) {}
    }

    notifyListeners();
  }

  Future<void> submitReview({
    required int movieId,
    required double ratingValue,
    String? comment,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.submitRating(
        movieId: movieId,
        value: ratingValue,
        comment: comment,
      );

      await fetchReviewsForMovie(movieId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteReview(int movieId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _api.deleteRating(movieId);

      await fetchReviewsForMovie(movieId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _recalculateAverage(int movieId) {
    final reviews = _movieReviewsCache[movieId] ?? [];
    if (reviews.isNotEmpty) {
      final sum = reviews.map((r) => r.value).reduce((a, b) => a + b);
      final average = sum / reviews.length;
      _movieAverageRatings[movieId] = double.parse(average.toStringAsFixed(1));
    } else {
      _movieAverageRatings[movieId] = 0.0;
    }
  }

  Future<void> updateReview({
    required int movieId,
    required double ratingValue,
    String? comment,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // Chama o PUT na API
      await _api.put('/ratings/$movieId', {
        'value': ratingValue,
        'comment': comment,
      });
      await fetchReviewsForMovie(movieId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
