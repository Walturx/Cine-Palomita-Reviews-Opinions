import 'package:flutter_repaso/models/movie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final User user;
  final String name;
  final String lastname;
  final int watched;
  final int pending;
  final int watching;
  final String? avatarUrl;
  final Map<String, MovieStatus> movieStatuses;

  ProfileLoaded({
    required this.user,
    required this.name,
    required this.lastname,
    required this.watched,
    required this.pending,
    required this.watching,
    this.avatarUrl,
    this.movieStatuses = const {},
  });
}

class ProfileError extends ProfileState {
  final String error;
  ProfileError({required this.error});
}
