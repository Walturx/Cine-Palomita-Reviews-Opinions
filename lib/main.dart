import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/auth_cubit.dart';
import 'package:flutter_repaso/cubits/auth_state.dart';
import 'package:flutter_repaso/cubits/movie_cubit.dart';
import 'package:flutter_repaso/cubits/profile_cubit.dart';
import 'package:flutter_repaso/env.dart';
import 'package:flutter_repaso/repositories/MovieRepository.dart';
import 'package:flutter_repaso/repositories/ProfileRepository.dart';
import 'package:flutter_repaso/router/app_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MovieCubit(Movierepository())..loadMovies(),
        ),
        BlocProvider(create: (context) => AuthCubit()..checkSession()),
        BlocProvider(
          create: (context) => ProfileCubit(Profilerepository())..loadProfile(),
        ),
      ],
      child: MaterialApp.router(
        title: 'CineLog',
        debugShowCheckedModeBanner: false,
        routerConfig: router,
        builder: (context, child) => BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoggedIn) {
              router.go('/home');
            } else if (state is AuthLoggedOut) {
              router.go('/login');
            }
          },
          child: child!,
        ),
      ),
    );
  }
}
