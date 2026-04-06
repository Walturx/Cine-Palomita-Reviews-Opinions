import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoggedIn extends AuthState {
  final User user;
  AuthLoggedIn({required this.user});
}

class AuthLoggedOut extends AuthState {}

class AuthError extends AuthState {
  final String error;
  AuthError({required this.error});
}
