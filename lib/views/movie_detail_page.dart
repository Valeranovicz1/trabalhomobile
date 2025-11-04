// lib/views/movie_detail_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/models/rating.dart';
import 'package:projetomobile/utils/app_colors.dart';
import 'package:projetomobile/viewmodels/auth_viewmodel.dart';
import 'package:projetomobile/viewmodels/rating_viewmodel.dart';
import 'package:projetomobile/viewmodels/movie_detail_viewmodel.dart';

class MovieDetailPage extends StatefulWidget {
  final Movie movie;
  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late MovieDetailViewModel _viewModel;
  final TextEditingController _commentController = TextEditingController();
  double _currentRating = 0.0;

  @override
  void initState() {
    super.initState();
    _viewModel = MovieDetailViewModel(
      authViewModel: Provider.of<AuthViewModel>(context, listen: false),
      ratingViewModel: Provider.of<RatingViewModel>(context, listen: false),
      movie: widget.movie,
    );

    final userReview = _viewModel.currentUserReview;
    if (userReview != null) {
      _currentRating = userReview.value;
      _commentController.text = userReview.comment ?? '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    _viewModel.dispose();
    super.dispose();
  }

  void _onSubmitReview() {
    _viewModel.submitReview(_currentRating, _commentController.text);
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avaliação salva!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _onDeleteReview() {
    _viewModel.deleteReview();
    setState(() {
      _currentRating = 0.0;
      _commentController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Avaliação removida.'),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.title),
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
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${widget.movie.year} • Dirigido por ${widget.movie.director}',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[400],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
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
                      widget.movie.description,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[300],
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildUserReviewForm(),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.darkGray),
                    const SizedBox(height: 16),
                    const Text(
                      'Avaliações',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    _buildReviewsList(),

                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom + 12,
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
          colors: [Colors.black.withValues(alpha: .6), Colors.transparent],
          stops: const [0.0, 0.9],
        ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
      },
      blendMode: BlendMode.dstIn,
      child: Image.network(
        widget.movie.imageUrl,
        width: double.infinity,
        height: 600,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const SizedBox(
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

  Widget _buildUserReviewForm() {
    return Consumer<MovieDetailViewModel>(
      builder: (context, viewModel, child) {
        if (viewModel.currentUser == null) {
          return const Text(
            'Faça login para avaliar este filme.',
            style: TextStyle(color: Colors.grey),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Deixe sua avaliação',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) {
                final ratingValue = index + 1.0;
                return IconButton(
                  icon: Icon(
                    ratingValue <= _currentRating
                        ? Icons.star
                        : Icons.star_border,
                    color: ratingValue <= _currentRating
                        ? Colors.amber
                        : Colors.grey[400],
                    size: 35,
                  ),
                  onPressed: () {
                    setState(() {
                      if (_currentRating == ratingValue) {
                        _currentRating = 0.0;
                      } else {
                        _currentRating = ratingValue;
                      }
                    });
                  },
                );
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Adicionar um comentário (opcional)',
                hintText: 'O que você achou do filme?',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: _onSubmitReview,
                  child: const Text('Salvar Avaliação'),
                ),
                const SizedBox(width: 8),
                if (viewModel.currentUserReview != null)
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.lightGray,
                    ),
                    onPressed: _onDeleteReview,
                    child: const Text('Deletar'),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildReviewsList() {
    return Consumer<RatingViewModel>(
      builder: (context, ratingViewModel, child) {
        final movieDetailViewModel = Provider.of<MovieDetailViewModel>(
          context,
          listen: false,
        );
        final reviews = ratingViewModel.getReviewsForMovie(
          movieDetailViewModel.movie.movie_id,
        );

        final isLoading = ratingViewModel.isLoading;

        if (isLoading && reviews.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!isLoading && reviews.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Este filme ainda não tem avaliações.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: reviews.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final review = reviews[index];
            return _buildReviewCard(review);
          },
        );
      },
    );
  }

  Widget _buildReviewCard(Rating review) {
    final formattedDate = DateFormat(
      'dd \'de\' MMM, yyyy',
      'pt_BR',
    ).format(review.timestamp.toDate());

    return Card(
      color: AppColors.lightBackground,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.darkGray,
                  child: const Icon(Icons.person, color: AppColors.lightGray),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formattedDate,
                        style: const TextStyle(
                          color: AppColors.lightGray,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(
                      review.value.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                  ],
                ),
              ],
            ),
            if (review.comment != null && review.comment!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Text(
                  review.comment!,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
