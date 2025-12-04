import 'package:flutter/material.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/models/user.dart';
import 'package:projetomobile/models/rating.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/viewmodels/rating_viewmodel.dart';

class MovieDetailViewModel with ChangeNotifier {
  final AuthViewModel _authViewModel;
  final RatingViewModel _ratingViewModel;
  final Movie _movie;

  MovieDetailViewModel({
    required AuthViewModel authViewModel,
    required RatingViewModel ratingViewModel,
    required Movie movie,
  }) : _authViewModel = authViewModel,
       _ratingViewModel = ratingViewModel,
       _movie = movie {
    _ratingViewModel.addListener(_onDataChanged);

    Future.microtask(() {
      loadReviews();
    });
  }

  Movie get movie => _movie;
  User? get currentUser => _authViewModel.currentUser;

  double get currentAverageRating {
    return _ratingViewModel.getMovieAverageRating(_movie.id);
  }

  Rating? get currentUserReview {
    if (currentUser != null) {
      return _ratingViewModel.getUserReviewForMovie(currentUser!.id, _movie.id);
    }
    return null;
  }

  void loadReviews() {
    _ratingViewModel.fetchReviewsForMovie(_movie.id);
  }

  Future<void> submitReview(double ratingValue, String? comment) async {
    if (currentUser == null) return;

    try {
      await _ratingViewModel.submitReview(
        movieId: _movie.id,
        ratingValue: ratingValue,
        comment: comment,
      );

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteReview() async {
    if (currentUser == null) return;

    try {
      await _ratingViewModel.deleteReview(_movie.id);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  void _onDataChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _ratingViewModel.removeListener(_onDataChanged);
    super.dispose();
  }
}
