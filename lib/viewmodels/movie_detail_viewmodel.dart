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
  }

  Movie get movie => _movie;
  User? get currentUser => _authViewModel.currentUser;

  Rating? get currentUserReview {
    if (currentUser != null) {
      return _ratingViewModel.getUserReviewForMovie(
        currentUser!.user_id,
        _movie.movie_id,
      );
    }
    return null;
  }

  List<Rating> get allReviewsForMovie {
    return _ratingViewModel.getReviewsForMovie(_movie.movie_id);
  }

  Future<void> submitReview(double ratingValue, String? comment) async {
    if (currentUser != null) {
      await _ratingViewModel.submitReview(
        user: currentUser!,
        movieId: _movie.movie_id,
        ratingValue: ratingValue,
        comment: (comment != null && comment.isEmpty) ? null : comment,
      );
    }
  }

  Future<void> deleteReview() async {
    if (currentUser != null) {
      await _ratingViewModel.deleteReview(
        currentUser!.user_id,
        _movie.movie_id,
      );
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
