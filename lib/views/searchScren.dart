import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/movie_cubit.dart';
import 'package:flutter_repaso/cubits/movie_state.dart';
import 'package:flutter_repaso/widgets/movie_cards.dart';
import 'package:go_router/go_router.dart';

class Searchscren extends StatefulWidget {
  Searchscren({Key? key}) : super(key: key);

  @override
  _SearchscrenState createState() => _SearchscrenState();
}

class _SearchscrenState extends State<Searchscren> {
  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => context.go('/home'),
            icon: Icon(Icons.arrow_back),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: size.height * 0.05),

          Center(
            child: Container(
              width: size.width * 0.85,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        labelText: 'Buscar',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 10),

                  IconButton(
                    onPressed: () {
                      context.read<MovieCubit>().searchMovies(
                        searchController.text,
                      );
                    },
                    icon: Icon(Icons.search),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.05),
          BlocBuilder<MovieCubit, MovieState>(
            builder: (context, state) {
              if (state is MovieLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is MovieError) {
                return Center(child: Text(state.error));
              }
              if (state is MovieLoaded) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: state.movies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MovieCards(movies: state.movies[index]);
                    },
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
