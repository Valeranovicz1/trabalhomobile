// lib/views/home_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/viewmodels/movie_viewmodel.dart';
import 'package:projetomobile/viewmodels/home_viewmodel.dart';
import 'package:projetomobile/views/movie_detail_page.dart';
import 'package:projetomobile/utils/app_colors.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // A estrutura do build (AppBar, FAB, Consumer) permanece a mesma
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Disponíveis'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFilterModal(context),
        child: const Icon(Icons.filter_list),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MovieViewModel>(
              builder: (context, movieViewModel, child) {
                if (movieViewModel.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Consumer<HomeViewModel>(
                  builder: (context, homeViewModel, child) {
                    final movies = homeViewModel.filteredMovies;
                    if (movies.isEmpty &&
                        homeViewModel.searchQuery.isNotEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum filme encontrado.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }
                    if (movies.isEmpty && homeViewModel.searchQuery.isEmpty) {
                      return const Center(
                        child: Text(
                          'Nenhum filme disponível no momento.',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: movies.length,
                      itemBuilder: (context, index) {
                        final movie = movies[index];
                        return _buildMovieCard(context, movie);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o Card de um filme (Exibindo a média de estrelas)
  Widget _buildMovieCard(BuildContext context, Movie movie) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        child: InkWell(
          splashColor: Theme.of(context).colorScheme.primary.withOpacity(0.3),
          highlightColor: Theme.of(
            context,
          ).colorScheme.primary.withOpacity(0.1),
          onTap: () {
            Future.delayed(const Duration(milliseconds: 200), () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MovieDetailPage(movie: movie),
                ),
              );
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Image.network(
                    movie.imageUrl,
                    width: 90,
                    height: 135,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 90,
                        height: 135,
                        color: Colors.grey[850],
                        child: Icon(
                          Icons.movie_creation_outlined,
                          color: Colors.grey[700],
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        '${movie.year} • Dirigido por ${movie.director}',
                        style: TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey[400],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12.0),
                      // Exibe a média de avaliações
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            movie.averageRating > 0
                                ? movie.averageRating.toStringAsFixed(1)
                                : 'Sem avaliações',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey[400],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- ATUALIZAÇÃO PRINCIPAL AQUI ---
  /// Abre o Modal de Filtros (Agora com RadioListTiles)
  void _openFilterModal(BuildContext context) {
    final viewModel = Provider.of<HomeViewModel>(context, listen: false);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) {
        final modalSearchController = TextEditingController(
          text: viewModel.searchQuery,
        );
        final bottomSystemPadding = MediaQuery.of(modalContext).padding.bottom;

        // O StatefulBuilder ainda é necessário para atualizar
        // os RadioButtons selecionados em tempo real.
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(modalContext).viewInsets.bottom,
              ),
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20 + bottomSystemPadding,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(modalContext).cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: modalSearchController,
                      onChanged: (value) {
                        // Chama o VM
                        viewModel.setSearchQuery(value);
                        // Atualiza a UI do modal (para o ícone 'X')
                        setModalState(() {});
                      },
                      decoration: InputDecoration(
                        labelText: 'Buscar por título...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        suffixIcon: modalSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  viewModel.setSearchQuery('');
                                  modalSearchController.clear();
                                  setModalState(() {});
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24.0),

                    // --- Início da Lista de Filtros ---
                    const Text(
                      'Ordenar por:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    RadioListTile<MovieSortOption>(
                      title: const Text('Padrão'),
                      value: MovieSortOption.none,
                      groupValue: viewModel.sortOption,
                      onChanged: (value) {
                        viewModel.setSortOption(value!);
                        setModalState(() {}); // Atualiza o modal
                      },
                    ),
                    RadioListTile<MovieSortOption>(
                      title: const Text('Ordem Alfabética (A-Z)'),
                      value: MovieSortOption.az,
                      groupValue: viewModel.sortOption,
                      onChanged: (value) {
                        viewModel.setSortOption(value!);
                        setModalState(() {});
                      },
                    ),
                    RadioListTile<MovieSortOption>(
                      title: const Text('Ordem Alfabética (Z-A)'),
                      value: MovieSortOption.za,
                      groupValue: viewModel.sortOption,
                      onChanged: (value) {
                        viewModel.setSortOption(value!);
                        setModalState(() {});
                      },
                    ),
                    RadioListTile<MovieSortOption>(
                      title: const Text('Melhor Avaliados'),
                      value: MovieSortOption.highestRated,
                      groupValue: viewModel.sortOption,
                      onChanged: (value) {
                        viewModel.setSortOption(value!);
                        setModalState(() {});
                      },
                    ),
                    RadioListTile<MovieSortOption>(
                      title: const Text('Pior Avaliados'),
                      value: MovieSortOption.lowestRated,
                      groupValue: viewModel.sortOption,
                      onChanged: (value) {
                        viewModel.setSortOption(value!);
                        setModalState(() {});
                      },
                    ),

                    // --- Fim da Lista de Filtros ---
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          viewModel.clearFilters();
                          modalSearchController.clear();
                          setModalState(() {});
                        },
                        child: const Text('Limpar Filtros'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
