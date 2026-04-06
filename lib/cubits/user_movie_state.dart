import 'package:flutter_repaso/models/movie.dart';

abstract class UserMovieState {}

class UserMovieInitial extends UserMovieState {}

class UserMovieLoaded extends UserMovieState {
  final MovieStatus movieStatus;
  final int? rating;
  final String? review;
  UserMovieLoaded({required this.movieStatus, this.rating, this.review});
}

class UserMovieLoading extends UserMovieState {}

class UserMovieSaving extends UserMovieState {}

class UserMovieError extends UserMovieState {
  final String error;
  UserMovieError({required this.error});
}
