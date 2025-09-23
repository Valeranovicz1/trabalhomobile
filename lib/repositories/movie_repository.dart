import 'package:projetomobile/models/movie.dart';

class MovieRepository {

  static List<Movie> movies = [
    Movie (
    movie_id:1,
    title: 'O Poderoso Chefão',
    imageUrl: 'https://i.ebayimg.com/images/g/R~4AAOSwoyVg3GoS/s-l1200.webp',
    description: 'A saga de uma família mafiosa italiana em Nova York, focada na transformação de Michael Corleone, de um relutante membro da família a um impiedoso chefe da máfia.',
    year: 1972,
    director: 'Francis Ford Coppola',
    ),
    Movie(
    movie_id:2,
    title: 'A Origem',
    imageUrl: 'https://img.elo7.com.br/product/original/2657A1E/poster-cartaz-filme-a-origem-2010-grande-g-frete-gratis-poster-de-filme.jpg',
    description: 'Um ladrão que rouba segredos corporativos através do uso da tecnologia de compartilhamento de sonhos recebe a tarefa inversa de plantar uma ideia na mente de um CEO.',
    year: 2010,
    director: 'Christopher Nolan',
    ),
    Movie(
    movie_id:3,
    title: 'Pulp Fiction: Tempo de Violência',
    imageUrl: 'https://br.web.img3.acsta.net/medias/nmedia/18/89/43/82/20052332.jpg',
    description: 'As vidas de dois assassinos de aluguel, um boxeador, a esposa de um gângster e um casal de assaltantes de lanchonetes se entrelaçam em quatro contos de violência e redenção.',
    year: 1994,
    director: 'Quentin Tarantino',
    ),
    Movie(
    movie_id:4,
    title: 'Clube da Luta',
    imageUrl: 'https://img.elo7.com.br/product/original/2692751/poster-cartaz-clube-da-luta-fight-club-1999-filme-cinema-presente-geek-nerd-decoracao-poster.jpg',
    description: 'Um trabalhador de escritório insone, procurando uma maneira de mudar sua vida, cruza o caminho com um fabricante de sabão e juntos formam um clube de luta clandestino que se transforma em algo muito, muito maior.',
    year: 1999,
    director: 'David Fincher',
  ),
    
  ];

  

  
}