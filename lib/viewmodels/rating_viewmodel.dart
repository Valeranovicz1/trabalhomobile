import 'package:flutter/material.dart';
import 'package:projetomobile/models/rating.dart';
import 'package:projetomobile/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RatingViewModel with ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final Map<String, Map<int, Rating>> _userRatingsCache = {};
  final Map<int, List<Rating>> _movieReviewsCache = {};
  final Map<int, double> _movieAverageRatings = {};
  bool _isLoading = true;

  bool get isLoading => _isLoading;
  bool _isRefreshingReviews = false;
  bool get isRefreshingReviews => _isRefreshingReviews;

  RatingViewModel() {
    _initRatingsCache();
  }

  Future<void> _initRatingsCache() async {
    try {
      final snapshot = await _db
          .collection('ratings')
          .orderBy('timestamp', descending: true)
          .get();
      for (var doc in snapshot.docs) {
        final rating = Rating.fromFirestore(doc.data());
        if (!_userRatingsCache.containsKey(rating.userId)) {
          _userRatingsCache[rating.userId] = {};
        }
        _userRatingsCache[rating.userId]![rating.movieId] = rating;
        if (!_movieReviewsCache.containsKey(rating.movieId)) {
          _movieReviewsCache[rating.movieId] = [];
        }
        _movieReviewsCache[rating.movieId]!.add(rating);
      }
      _recalculateAllAverages();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshReviewsForMovie(int movieId) async {
    _isRefreshingReviews = true;
    notifyListeners();

    try {
      final snapshot = await _db
          .collection('ratings')
          .where('movieId', isEqualTo: movieId)
          .orderBy('timestamp', descending: true)
          .get();
      _movieReviewsCache[movieId] = [];

      for (var doc in snapshot.docs) {
        final rating = Rating.fromFirestore(doc.data());
        _movieReviewsCache[movieId]!.add(rating);

        if (!_userRatingsCache.containsKey(rating.userId)) {
          _userRatingsCache[rating.userId] = {};
        }
        _userRatingsCache[rating.userId]![rating.movieId] = rating;
      }

      _recalculateAverage(movieId);
    } finally {
      _isRefreshingReviews = false;
      notifyListeners();
    }
  }

  double getMovieAverageRating(int movieId) {
    return _movieAverageRatings[movieId] ?? 0.0;
  }

  Rating? getUserReviewForMovie(String userId, int movieId) {
    return _userRatingsCache[userId]?[movieId];
  }

  List<Rating> getReviewsForMovie(int movieId) {
    return _movieReviewsCache[movieId] ?? [];
  }

  Future<void> submitReview({
    required User user,
    required int movieId,
    required double ratingValue,
    String? comment,
  }) async {
    final docId = "${user.user_id}_$movieId";
    final docRef = _db.collection('ratings').doc(docId);

    double finalRatingValue = ratingValue;
    if (finalRatingValue == 0.0) {
      finalRatingValue =
          getUserReviewForMovie(user.user_id, movieId)?.value ?? 0.0;
      if (finalRatingValue == 0.0) return;
    }

    final newReview = Rating(
      userId: user.user_id,
      movieId: movieId,
      value: finalRatingValue,
      comment: (comment != null && comment.isEmpty) ? null : comment,
      timestamp: Timestamp.now(),
      userName: user.name,
      userPhotoUrl: null,
    );
    await docRef.set(newReview.toJson());

    if (!_userRatingsCache.containsKey(user.user_id)) {
      _userRatingsCache[user.user_id] = {};
    }
    _userRatingsCache[user.user_id]![movieId] = newReview;
    if (!_movieReviewsCache.containsKey(movieId)) {
      _movieReviewsCache[movieId] = [];
    }
    _movieReviewsCache[movieId]!.removeWhere((r) => r.userId == user.user_id);
    _movieReviewsCache[movieId]!.insert(0, newReview);

    _recalculateAverage(movieId);
    notifyListeners();
  }

  Future<void> deleteReview(String userId, int movieId) async {
    final docId = "${userId}_$movieId";
    await _db.collection('ratings').doc(docId).delete();
    _userRatingsCache[userId]?.remove(movieId);
    _movieReviewsCache[movieId]?.removeWhere((r) => r.userId == userId);
    _recalculateAverage(movieId);
    notifyListeners();
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

  void _recalculateAllAverages() {
    final allMovieIds = _movieReviewsCache.keys;
    for (var movieId in allMovieIds) {
      _recalculateAverage(movieId);
    }
  }
}
