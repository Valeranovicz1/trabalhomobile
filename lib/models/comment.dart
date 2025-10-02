
import 'package:projetomobile/models/user.dart';
import 'package:projetomobile/models/movie.dart';

class Comment{

  final User user;
  final Movie movie;
  final String comment;

  Comment({
    required this.user,
    required this.movie,
    required this.comment
  });
}