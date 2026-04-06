import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/movie_cubit.dart';
import 'package:flutter_repaso/models/movie.dart';
import 'package:flutter_repaso/repositories/MovieRepository.dart';
import 'package:flutter_repaso/views/addMovie.dart';
import 'package:flutter_repaso/views/homeScren.dart';
import 'package:flutter_repaso/views/loginScreen.dart';
import 'package:flutter_repaso/views/movieScreen.dart';
import 'package:flutter_repaso/views/profileScreen.dart';
import 'package:flutter_repaso/views/searchScren.dart';
import 'package:flutter_repaso/views/splashScreen.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'splash',
      builder: (context, state) => Splashscreen(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => BlocProvider(
        create: (context) => MovieCubit(Movierepository())..loadMovies(),
        child: HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (context, state) => BlocProvider(
        create: (context) => MovieCubit(Movierepository()),
        child: Searchscren(),
      ),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => ProfileScreen(),
    ),
    GoRoute(
      path: '/movie',
      name: 'movie',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return Moviescreen(movie: movie);
      },
    ),
    GoRoute(
      path: '/addMovie',
      name: 'addMovie',
      builder: (context, state) => Addmovie(),
    ),
  ],
);
