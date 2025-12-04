import 'dart:async';
import 'package:flutter/material.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/services/api_service.dart';

class MovieViewModel with ChangeNotifier {
  // Instância do serviço para fazer as requisições
  final ApiService _api = ApiService();

  List<Movie> _movies = [];
  bool _isLoading = true;
  String? _errorMessage;

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMovies() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final dynamic response = await _api
          .get('/movies/')
          .timeout(
            const Duration(seconds: 60),
            onTimeout: () {
              throw TimeoutException(
                'O servidor demorou muito para responder.',
              );
            },
          );

      final List<dynamic> list = response as List<dynamic>;
      _movies = list.map((json) => Movie.fromJson(json)).toList();

      for (var movie in _movies) {
        try {
          final ratings = await _api.getRatings(movie.id);

          if (ratings.isNotEmpty) {
            final sum = ratings.map((r) => r.value).reduce((a, b) => a + b);
            final average = sum / ratings.length;

            movie.averageRating = average;
          } else {
            movie.averageRating = 0.0;
          }
        } catch (e) {
          print("Erro ao calcular rating para o filme ${movie.title}: $e");
        }
      }
    } on TimeoutException catch (_) {
      _errorMessage = 'Tempo limite excedido. Verifique sua conexão.';
      _movies = [];
    } catch (e) {
      _errorMessage = 'Não foi possível carregar os filmes.\nErro: $e';
      _movies = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
