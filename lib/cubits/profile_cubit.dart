import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/profile_state.dart';
import 'package:flutter_repaso/main.dart';
import 'package:flutter_repaso/models/movie.dart';
import 'package:flutter_repaso/repositories/ProfileRepository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final Profilerepository _repository;
  ProfileCubit(this._repository) : super(ProfileInitial());

  void loadProfile() async {
    emit(ProfileLoading());
    try {
      final result = await supabase.auth.currentSession;

      if (result != null) {
        final profile = await _repository.getProfile(result.user.id);
        final movies = await _repository.getUserMovies(result.user.id);
        final watched = movies.where((m) => m['status'] == 'watched').length;
        final pending = movies.where((m) => m['status'] == 'pending').length;
        final watching = movies.where((m) => m['status'] == 'watching').length;
        final movieStatuses = <String, MovieStatus>{};
        for (var movie in movies) {
          movieStatuses[movie['tmdb_id'].toString()] = MovieStatus.values
              .firstWhere((s) => s.name == movie['status']);
        }
        emit(
          ProfileLoaded(
            user: result.user,
            name: profile['name'],
            lastname: profile['lastname'],
            watched: watched,
            pending: pending,
            watching: watching,
            avatarUrl: profile['avatar_url'],
            movieStatuses: movieStatuses,
          ),
        );
      } else {
        emit(ProfileError(error: 'No hay sesion activa'));
      }
    } catch (e) {
      emit(ProfileError(error: e.toString()));
    }
  }

  void uploadAvatar(File image) async {
    final session = supabase.auth.currentSession;
    if (session == null) return;
    emit(ProfileLoading());
    try {
      final userId = session.user.id;
      final extension = image.path.split('.').last;
      final path = 'avatars/$userId.$extension';

      await supabase.storage
          .from('avatars')
          .upload(path, image, fileOptions: FileOptions(upsert: true));
      final url = supabase.storage.from('avatars').getPublicUrl(path);
      await _repository.updateAvatar(userId, url);
      loadProfile();
    } catch (e) {
      print(e.toString());
      emit(ProfileError(error: e.toString()));
    }
  }
}
