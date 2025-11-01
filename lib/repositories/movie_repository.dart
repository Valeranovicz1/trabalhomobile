// lib/repositories/movie_repository.dart

import 'package:projetomobile/models/movie.dart';

class MovieRepository {
  static List<Movie> movies = [
    Movie(
      movie_id: 1,
      title: 'O Poderoso Chefão',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/oJagOzBu9Rdd9BrciseCm3U3MCU.jpg',
      description: 'A saga de uma família mafiosa italiana em Nova York...',
      year: 1972,
      director: 'Francis Ford Coppola',
      averageRating: 4.9,
    ),
    Movie(
      movie_id: 2,
      title: 'A Origem',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/n3Vnq3FvBgjFqX6G5f8zjwCeQC0.jpg',
      description: 'Um ladrão que rouba segredos corporativos...',
      year: 2010,
      director: 'Christopher Nolan',
      averageRating: 4.7,
    ),
    Movie(
      movie_id: 3,
      title: 'Pulp Fiction: Tempo de Violência',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/tptjnB2LDbuUWya9Cx5sQtv5hqb.jpg',
      description: 'As vidas de dois assassinos de aluguel...',
      year: 1994,
      director: 'Quentin Tarantino',
      averageRating: 4.8,
    ),
    Movie(
      movie_id: 4,
      title: 'Clube da Luta',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/mCICnh7QBH0gzYaTQChBDDVIKdm.jpg',
      description: 'Um trabalhador de escritório insone...',
      year: 1999,
      director: 'David Fincher',
      averageRating: 4.6,
    ),
    Movie(
      movie_id: 5,
      title: 'Matrix',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/f89U3ADr1oiB1s9GkdPOEpXUk5H.jpg',
      description: 'Um hacker descobre a verdadeira natureza da realidade...',
      year: 1999,
      director: 'Lana & Lilly Wachowski',
      averageRating: 4.7,
    ),
    Movie(
      movie_id: 6,
      title: 'Interestelar',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/rAiYTfKGqDCRIIqo664sY9XZIvQ.jpg',
      description: 'Um grupo de exploradores viaja por um buraco de minhoca...',
      year: 2014,
      director: 'Christopher Nolan',
      averageRating: 4.8,
    ),
    Movie(
      movie_id: 7,
      title: 'O Senhor dos Anéis: A Sociedade do Anel',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/6oom5QYQ2yQTMJIbnvbkBL9cHo6.jpg',
      description: 'Um jovem hobbit deve destruir um anel poderoso...',
      year: 2001,
      director: 'Peter Jackson',
      averageRating: 4.9,
    ),
    Movie(
      movie_id: 8,
      title: 'O Senhor dos Anéis: As Duas Torres',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/rrGlNlzFTrXFNGXsD7NNlxq4BPb.jpg',
      description: 'A jornada da Sociedade do Anel continua...',
      year: 2002,
      director: 'Peter Jackson',
      averageRating: 4.8,
    ),
    Movie(
      movie_id: 9,
      title: 'O Senhor dos Anéis: O Retorno do Rei',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/rCzpDGLbOoPwLjy3OAm5NUPOTrC.jpg',
      description: 'A batalha final pela Terra Média...',
      year: 2003,
      director: 'Peter Jackson',
      averageRating: 4.9,
    ),
    Movie(
      movie_id: 10,
      title: 'Batman: O Cavaleiro das Trevas',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/qJ2tW6WMUDux911r6m7haRef0WH.jpg',
      description: 'Batman enfrenta o caos causado pelo Coringa...',
      year: 2008,
      director: 'Christopher Nolan',
      averageRating: 4.9,
    ),
    Movie(
      movie_id: 11,
      title: 'Forrest Gump',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/arw2vcBveWOVZr6pxd9XTd1TdQa.jpg',
      description:
          'A história da vida de um homem simples com um coração puro...',
      year: 1994,
      director: 'Robert Zemeckis',
      averageRating: 4.8,
    ),
    Movie(
      movie_id: 12,
      title: 'Gladiador',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/ty8TGRuvJLPUmAR1H1nRIsgwvim.jpg',
      description:
          'Um general romano busca vingança contra o imperador corrupto...',
      year: 2000,
      director: 'Ridley Scott',
      averageRating: 4.6,
    ),
    Movie(
      movie_id: 13,
      title: 'O Resgate do Soldado Ryan',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/uqx37cS8cpHg8U35f9U5IBlrCV3.jpg',
      description:
          'Soldados arriscam suas vidas para resgatar um companheiro...',
      year: 1998,
      director: 'Steven Spielberg',
      averageRating: 4.7,
    ),
    Movie(
      movie_id: 14,
      title: 'Coringa',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/udDclJoHjfjb8Ekgsd4FDteOkCU.jpg',
      description: 'A transformação de Arthur Fleck no Coringa...',
      year: 2019,
      director: 'Todd Phillips',
      averageRating: 3.9,
    ),
    Movie(
      movie_id: 15,
      title: 'O Silêncio dos Inocentes',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/uS9m8OBk1A8eM9I042bx8XXpqAq.jpg',
      description: 'Uma jovem agente do FBI busca ajuda de um assassino...',
      year: 1991,
      director: 'Jonathan Demme',
      averageRating: 4.1,
    ),
    Movie(
      movie_id: 16,
      title: 'Os Infiltrados',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/jyAgiqVSx5fl0NNj7WoGGKweXrL.jpg',
      description: 'Um policial infiltrado e um criminoso infiltrado...',
      year: 2006,
      director: 'Martin Scorsese',
      averageRating: 4.2,
    ),
    Movie(
      movie_id: 17,
      title: 'O Exterminador do Futuro 2: O Julgamento Final',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/weVXMD5QBGeQil4HEATZqAkXeEc.jpg',
      description:
          'Um ciborgue deve proteger um garoto destinado a salvar a humanidade...',
      year: 1991,
      director: 'James Cameron',
      averageRating: 4.1,
    ),
    Movie(
      movie_id: 18,
      title: 'De Volta para o Futuro',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/fNOH9f1aA7XRTzl1sAOx9iF553Q.jpg',
      description: 'Um adolescente viaja acidentalmente para o passado...',
      year: 1985,
      director: 'Robert Zemeckis',
      averageRating: 4.7,
    ),
    Movie(
      movie_id: 19,
      title: 'Django Livre',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/7oWY8VDWW7thTzWh3OKYRkWUlD5.jpg',
      description: 'Um escravo liberto busca resgatar sua esposa...',
      year: 2012,
      director: 'Quentin Tarantino',
      averageRating: 4.6,
    ),
    Movie(
      movie_id: 20,
      title: 'Cidade de Deus',
      imageUrl:
          'https://media.themoviedb.org/t/p/w300_and_h450_bestv2/k7eYdWvhYQyRQoU2TB2A2Xu2TfD.jpg',
      description:
          'A ascensão do crime organizado em uma favela do Rio de Janeiro...',
      year: 2002,
      director: 'Fernando Meirelles, Kátia Lund',
      averageRating: 4.8,
    ),
  ];

  static void updateMovieAverageRating(int movieId, double newAverage) {
    final index = movies.indexWhere((m) => m.movie_id == movieId);
    if (index != -1) {
      movies[index].averageRating = newAverage;
    }
  }
}
