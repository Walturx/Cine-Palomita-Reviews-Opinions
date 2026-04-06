import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/movie_cubit.dart';
import 'package:flutter_repaso/cubits/movie_state.dart';
import 'package:flutter_repaso/cubits/profile_cubit.dart';
import 'package:flutter_repaso/cubits/profile_state.dart';

import 'package:flutter_repaso/widgets/movie_cards.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CineLog'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () => context.go('/profile'),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => context.go('/search'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<MovieCubit, MovieState>(
              builder: (context, state) {
                final profileState = context.watch<ProfileCubit>().state;

                if (state is MovieLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is MovieError) {
                  return Center(child: Text(state.error));
                }
                if (state is MovieLoaded) {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: state.movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MovieCards(
                        movies: state.movies[index],
                        status: profileState is ProfileLoaded
                            ? profileState.movieStatuses[state.movies[index].id]
                            : null,
                      );
                    },
                  );
                }
                return SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/addMovie'),
        child: Icon(Icons.add),
      ),
    );
  }
}
