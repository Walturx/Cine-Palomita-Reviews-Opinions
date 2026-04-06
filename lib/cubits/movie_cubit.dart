import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/movie_state.dart';
import 'package:flutter_repaso/repositories/MovieRepository.dart';

class MovieCubit extends Cubit<MovieState> {
  final Movierepository _repository;
  MovieCubit(this._repository) : super(MovieInitial());

  void loadMovies() async {
    emit(MovieLoading());
    try {
      final movies = await _repository.getPopularMovies();
      emit(MovieLoaded(movies: movies));
    } catch (e) {
      print('Error: $e');
      emit(MovieError(error: 'Error al cargar'));
    }
  }

  void searchMovies(String query) async {
    emit(MovieLoading());
    try {
      final movies = await _repository.searchMovies(query);
      emit(MovieLoaded(movies: movies));
    } catch (e) {
      emit(MovieError(error: 'Error al buscar'));
    }
  }
}
