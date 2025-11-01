import 'package:flutter/material.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/models/user.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/viewmodels/rating_viewmodel.dart';

class MovieDetailViewModel with ChangeNotifier {
  final AuthViewModel _authViewModel;
  final RatingViewModel _ratingViewModel;
  final Movie _movie;

  Movie get movie => _movie;
  User? get currentUser => _authViewModel.currentUser;

  double get currentUserRating {
    if (currentUser != null) {
      return _ratingViewModel.getUserRatingForMovie(
        currentUser!.user_id,
        _movie.movie_id,
      );
    }
    return 0.0;
  }

  MovieDetailViewModel({
    required AuthViewModel authViewModel,
    required RatingViewModel ratingViewModel,
    required Movie movie,
  }) : _authViewModel = authViewModel,
       _ratingViewModel = ratingViewModel,
       _movie = movie {
    _ratingViewModel.addListener(_onRatingChanged);
  }
  void rateMovie(double ratingValue) {
    if (currentUser != null) {
      _ratingViewModel.rateMovie(
        userId: currentUser!.user_id,
        movieId: _movie.movie_id,
        ratingValue: ratingValue,
      );
      notifyListeners();
    }
  }

  void _onRatingChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _ratingViewModel.removeListener(_onRatingChanged);
    super.dispose();
  }
}
