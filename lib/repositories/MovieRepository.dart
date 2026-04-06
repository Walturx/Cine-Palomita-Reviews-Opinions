import 'package:flutter_repaso/models/movie.dart';
import 'package:flutter_repaso/services/movie_services.dart';

class Movierepository {
  Future<List<Movie>> getPopularMovies() async {
    return await MovieService().getPopularMovies();
  }

  Future<List<Movie>> searchMovies(String query) async {
    return await MovieService().fetchsearchMovies(query);
  }
}
