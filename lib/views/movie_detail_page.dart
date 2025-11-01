import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/viewmodels/rating_viewmodel.dart';
import 'package:projetomobile/viewmodels/movie_detail_viewmodel.dart';

class MovieDetailPage extends StatelessWidget {
  final Movie movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MovieDetailViewModel(
        authViewModel: Provider.of<AuthViewModel>(context, listen: false),
        ratingViewModel: Provider.of<RatingViewModel>(context, listen: false),
        movie: movie,
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(movie.title),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderImage(context),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${movie.year} • Dirigido por ${movie.director}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Sua Avaliação',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),

                    _buildRatingStars(),

                    const SizedBox(height: 24),
                    const Text(
                      'Sinopse',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      movie.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderImage(BuildContext context) {
    return ShaderMask(
      shaderCallback: (rect) {
        return LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
          stops: const [0.0, 0.9],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Image.network(
        movie.imageUrl,
        width: double.infinity,
        height: 600,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return SizedBox(
            width: double.infinity,
            height: 600,
            child: Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 600,
            color: Colors.grey[850],
            child: Icon(Icons.broken_image, color: Colors.grey[700], size: 60),
          );
        },
      ),
    );
  }

  Widget _buildRatingStars() {
    return Consumer<MovieDetailViewModel>(
      builder: (context, viewModel, child) {
        final currentRating = viewModel.currentUserRating;

        if (viewModel.currentUser == null) {
          return const Text(
            'Faça login para avaliar este filme.',
            style: TextStyle(color: Colors.grey),
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: List.generate(5, (index) {
            final ratingValue = index + 1.0;
            return IconButton(
              icon: Icon(
                ratingValue <= currentRating ? Icons.star : Icons.star_border,
                color: ratingValue <= currentRating
                    ? Colors.amber
                    : Colors.grey[400],
                size: 35,
              ),
              onPressed: () {
                viewModel.rateMovie(ratingValue);
              },
            );
          }),
        );
      },
    );
  }
}
