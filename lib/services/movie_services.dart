import 'package:dio/dio.dart';
import 'package:flutter_repaso/env.dart';
import 'package:flutter_repaso/models/movie.dart';

class MovieService {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      headers: {'Authorization': tmdbBearerToken, 'accept': 'application/json'},
    ),
  );

  Future<List<Movie>> getPopularMovies() async {
    final response = await dio.get('/movie/popular');
    final List result = response.data['results'];
    return result.map((json) => Movie.fromJson(json)).toList();
  }

  Future<List<Movie>> fetchsearchMovies(String query) async {
    final response = await dio.get(
      '/search/movie',
      queryParameters: {'query': query},
    );
    final List result = response.data['results'];
    return result.map((json) => Movie.fromJson(json)).toList();
  }
}
