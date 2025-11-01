// lib/viewmodels/home_viewmodel.dart
import 'package:flutter/material.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/viewmodels/movie_viewmodel.dart';
import 'package:projetomobile/viewmodels/rating_viewmodel.dart';

enum MovieSortOption { none, az, za, highestRated, lowestRated }

class HomeViewModel with ChangeNotifier {
  final MovieViewModel _movieViewModel;
  final RatingViewModel _ratingViewModel;

  List<Movie> _allMovies = [];
  List<Movie> _filteredMovies = [];
  String _searchQuery = '';
  MovieSortOption _sortOption = MovieSortOption.none;

  List<Movie> get filteredMovies => _filteredMovies;
  String get searchQuery => _searchQuery;
  MovieSortOption get sortOption => _sortOption;

  HomeViewModel(this._movieViewModel, this._ratingViewModel) {
    _loadMovies();
    _ratingViewModel.addListener(_onRatingsChanged);
  }

  void _onRatingsChanged() {
    _applyFilters();
  }

  void _loadMovies() {
    _allMovies = _movieViewModel.movies.map((movie) {
      movie.averageRating = _ratingViewModel.getMovieAverageRating(
        movie.movie_id,
      );
      return movie;
    }).toList();
    _applyFilters();
  }

  void setSearchQuery(String query) {
    if (_searchQuery != query) {
      _searchQuery = query;
      _applyFilters();
    }
  }

  void cycleSortOption() {
    if (_sortOption == MovieSortOption.none) {
      _sortOption = MovieSortOption.az;
    } else if (_sortOption == MovieSortOption.az) {
      _sortOption = MovieSortOption.za;
    } else if (_sortOption == MovieSortOption.za) {
      _sortOption = MovieSortOption.highestRated;
    } else if (_sortOption == MovieSortOption.highestRated) {
      _sortOption = MovieSortOption.lowestRated;
    } else {
      _sortOption = MovieSortOption.none;
    }
    _applyFilters();
  }

  void clearFilters() {
    _searchQuery = '';
    _sortOption = MovieSortOption.none;
    _applyFilters();
  }

  void _applyFilters() {
    List<Movie> tempMovies = List.from(_allMovies);

    if (_searchQuery.isNotEmpty) {
      tempMovies = tempMovies.where((movie) {
        return movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    tempMovies = tempMovies.map((movie) {
      movie.averageRating = _ratingViewModel.getMovieAverageRating(
        movie.movie_id,
      );
      return movie;
    }).toList();

    if (_sortOption == MovieSortOption.az) {
      tempMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortOption == MovieSortOption.za) {
      tempMovies.sort((a, b) => b.title.compareTo(a.title));
    } else if (_sortOption == MovieSortOption.highestRated) {
      tempMovies.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    } else if (_sortOption == MovieSortOption.lowestRated) {
      tempMovies.sort((a, b) => a.averageRating.compareTo(b.averageRating));
    }

    _filteredMovies = tempMovies;
    notifyListeners();
  }

  Widget buildSortIcon() {
    IconData iconData;
    switch (_sortOption) {
      case MovieSortOption.az:
        iconData = Icons.arrow_upward;
        break;
      case MovieSortOption.za:
        iconData = Icons.arrow_downward;
        break;
      case MovieSortOption.highestRated:
        iconData = Icons.star;
        break;
      case MovieSortOption.lowestRated:
        iconData = Icons.star_border;
        break;
      default:
        iconData = Icons.unfold_more;
    }
    return Icon(iconData, key: ValueKey<MovieSortOption>(_sortOption));
  }

  @override
  void dispose() {
    _ratingViewModel.removeListener(_onRatingsChanged);
    super.dispose();
  }
}
