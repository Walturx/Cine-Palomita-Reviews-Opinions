import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/user_movie_state.dart';
import 'package:flutter_repaso/main.dart';
import 'package:flutter_repaso/models/movie.dart';
import 'package:flutter_repaso/repositories/UserMovieRepository.dart';

class UserMovieCubit extends Cubit<UserMovieState> {
  final Usermovierepository _repository;

  UserMovieCubit(this._repository) : super(UserMovieInitial());

  void loadUsermovie(movieId) async {
    emit(UserMovieLoading());
    try {
      final result = supabase.auth.currentSession;
      if (result == null) {
        emit(UserMovieError(error: 'No hay sesion activa'));
        return;
      }
      final userMovies = await _repository.getUserMovie(
        movieId,
        result.user.id,
      );

      if (userMovies == null) {
        emit(UserMovieInitial());
      } else {
        emit(
          UserMovieLoaded(
            movieStatus: MovieStatus.values.byName(userMovies['status']),
            rating: (userMovies['rating'] as num?)?.toInt(),
            review: userMovies['review'],
          ),
        );
      }
    } catch (e) {
      emit(UserMovieError(error: e.toString()));
    }
  }

  void saveUserMovie(
    String movieId,
    MovieStatus status,
    int? rating,
    String? review,
  ) async {
    emit(UserMovieSaving());
    try {
      final session = supabase.auth.currentSession;
      if (session == null) {
        emit(UserMovieError(error: 'No hay sesion activa'));
        return;
      }
      await _repository.saveUserMovie(
        movieId,
        session.user.id,
        status.name,
        rating,
        review,
      );
      emit(
        UserMovieLoaded(movieStatus: status, rating: rating, review: review),
      );
    } catch (e) {
      emit(UserMovieError(error: e.toString()));
    }
  }
}
