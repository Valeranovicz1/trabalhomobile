// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:projetomobile/models/movie.dart';
import 'package:projetomobile/repositories/movie_repository.dart';
import 'package:projetomobile/pages/movie_detail_page.dart';

// Enum para um controle claro e seguro das opções de ordenação.
enum SortOption { none, az, za }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // A lista original e imutável de filmes, carregada do repositório.
  late List<Movie> _allMovies;
  // A lista que é efetivamente exibida na tela, resultado dos filtros aplicados.
  List<Movie> _filteredMovies = [];

  // Variáveis para guardar o estado atual dos filtros.
  String _searchQuery = '';
  SortOption _sortOption = SortOption.none;

  @override
  void initState() {
    super.initState();
    _allMovies = MovieRepository.movies;
    _applyFilters();
  }

  // Função central que aplica a busca e a ordenação na lista de filmes.
  void _applyFilters() {
    List<Movie> tempMovies = List.from(_allMovies);

    // 1. Filtra por busca (se houver texto no campo de busca).
    if (_searchQuery.isNotEmpty) {
      tempMovies = tempMovies.where((movie) {
        return movie.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    // 2. Ordena a lista resultante.
    if (_sortOption == SortOption.az) {
      tempMovies.sort((a, b) => a.title.compareTo(b.title));
    } else if (_sortOption == SortOption.za) {
      tempMovies.sort((a, b) => b.title.compareTo(a.title));
    }

    // Atualiza a interface com a lista final.
    setState(() {
      _filteredMovies = tempMovies;
    });
  }

  // Navega para a tela de perfil (funcionalidade futura).
  void _navigateToUserProfile() {
    print("Botão de perfil do usuário clicado!");
  }

  // Alterna entre os três estados de ordenação: neutro, A-Z e Z-A.
  void _cycleSortOption(StateSetter setModalState) {
    setModalState(() {
      if (_sortOption == SortOption.none) {
        _sortOption = SortOption.az;
      } else if (_sortOption == SortOption.az) {
        _sortOption = SortOption.za;
      } else {
        _sortOption = SortOption.none;
      }
    });
    _applyFilters();
  }

  // Retorna o ícone apropriado para o estado de ordenação atual.
  Widget _buildSortIcon() {
    IconData iconData;
    switch (_sortOption) {
      case SortOption.az:
        iconData = Icons.arrow_upward;
        break;
      case SortOption.za:
        iconData = Icons.arrow_downward;
        break;
      default:
        iconData = Icons.unfold_more;
    }
    // A Key é essencial para o AnimatedSwitcher detectar a mudança de widget.
    return Icon(iconData, key: ValueKey<SortOption>(_sortOption));
  }

  // Abre o painel inferior (Modal Bottom Sheet) com as opções de filtro.
  void _openFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final modalSearchController = TextEditingController(text: _searchQuery);
        final bottomSystemPadding = MediaQuery.of(context).padding.bottom;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Container(
                // O padding inferior se adapta à barra de navegação do sistema.
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  20 + bottomSystemPadding,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
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
                        setModalState(() => _searchQuery = value);
                        _applyFilters();
                      },
                      decoration: InputDecoration(
                        labelText: 'Buscar por título...',
                        prefixIcon: const Icon(Icons.search),
                        border: const OutlineInputBorder(),
                        suffixIcon: modalSearchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setModalState(() {
                                    modalSearchController.clear();
                                    _searchQuery = '';
                                  });
                                  _applyFilters();
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text(
                        'Ordem Alfabética',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: animation,
                              child: child,
                            ),
                          );
                        },
                        child: _buildSortIcon(),
                      ),
                      onTap: () => _cycleSortOption(setModalState),
                    ),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () {
                          setModalState(() {
                            modalSearchController.clear();
                            _searchQuery = '';
                            _sortOption = SortOption.none;
                          });
                          _applyFilters();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Disponíveis'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, size: 30),
            onPressed: _navigateToUserProfile,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openFilterModal,
        child: const Icon(Icons.filter_list),
      ),
      body: Column(
        children: [
          Expanded(
            child: _filteredMovies.isEmpty
                ? const Center(
                    child: Text(
                      'Nenhum filme encontrado.',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredMovies.length,
                    itemBuilder: (context, index) {
                      final movie = _filteredMovies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 4.0,
                        ),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: InkWell(
                            // NOVO: Cores explícitas para o efeito de clique
                            splashColor: Theme.of(context).colorScheme.primary
                                .withOpacity(0.3), // Cor da ondulação
                            highlightColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1), // Cor ao pressionar

                            onTap: () {
                              Future.delayed(
                                const Duration(milliseconds: 200),
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          MovieDetailPage(movie: movie),
                                    ),
                                  );
                                },
                              );
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
                                      errorBuilder:
                                          (context, error, stackTrace) {
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.favorite_border,
                                              color: Colors.grey[400],
                                              size: 20,
                                            ),
                                            const SizedBox(width: 16),
                                            Icon(
                                              Icons.visibility_outlined,
                                              color: Colors.grey[400],
                                              size: 20,
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
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
