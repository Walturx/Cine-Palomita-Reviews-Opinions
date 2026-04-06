import 'package:flutter_repaso/models/movie.dart';

abstract class MovieState {}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  MovieLoaded({required this.movies});
}

class MovieError extends MovieState {
  final String error;
  MovieError({required this.error});
}
