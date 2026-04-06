import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/auth_state.dart';
import 'package:flutter_repaso/main.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  void signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      final result = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      if (result.user != null) {
        emit(AuthLoggedIn(user: result.user!));
      } else {
        emit(AuthError(error: 'Usuario no encontrado'));
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  void signOut() async {
    emit(AuthLoading());
    try {
      await supabase.auth.signOut();
      emit(AuthLoggedOut());
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }

  void signUp(
    String name,
    String lastname,
    String email,
    String password,
  ) async {
    emit(AuthLoading());
    try {
      final result = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      if (result.user != null) {
        await supabase.from('profiles').insert({
          'id': result.user!.id,
          'name': name,
          'lastname': lastname,
        });
        emit(AuthLoggedIn(user: result.user!));
      } else {
        emit(AuthError(error: 'Usuario no encontrado'));
      }
    } catch (e) {
      print(e);
      emit(AuthError(error: e.toString()));
    }
  }

  void checkSession() async {
    emit(AuthLoading());
    try {
      final result = await supabase.auth.currentSession;
      if (result != null) {
        emit(AuthLoggedIn(user: result.user));
      } else {
        emit(AuthLoggedOut());
      }
    } catch (e) {
      emit(AuthError(error: e.toString()));
    }
  }
}
