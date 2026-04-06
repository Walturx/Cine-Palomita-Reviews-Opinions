import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_repaso/cubits/profile_cubit.dart';
import 'package:flutter_repaso/cubits/user_movie_cubit.dart';
import 'package:flutter_repaso/cubits/user_movie_state.dart';
import 'package:flutter_repaso/models/movie.dart';
import 'package:flutter_repaso/repositories/UserMovieRepository.dart';
import 'package:go_router/go_router.dart';

class Moviescreen extends StatefulWidget {
  final Movie movie;
  Moviescreen({Key? key, required this.movie}) : super(key: key);

  @override
  _MoviescreenState createState() => _MoviescreenState();
}

class _MoviescreenState extends State<Moviescreen> {
  MovieStatus? selectedStatus;
  int? selectedRating;
  TextEditingController reviewController = TextEditingController();
  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (context) =>
          UserMovieCubit(Usermovierepository())..loadUsermovie(widget.movie.id),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.title),
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          leading: IconButton(
            onPressed: () => context.pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: BlocListener<UserMovieCubit, UserMovieState>(
          listener: (context, state) {
            if (state is UserMovieLoaded) {
              context.read<ProfileCubit>().loadProfile();
            }
          },
          child: BlocBuilder<UserMovieCubit, UserMovieState>(
            builder: (context, state) {
              if (state is UserMovieLoading) {
                return Center(child: CircularProgressIndicator());
              }
              if (state is UserMovieLoaded && selectedStatus == null) {
                selectedStatus = state.movieStatus;
                selectedRating = state.rating;
                reviewController.text = state.review ?? '';
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Image.network(
                      widget.movie.poster_path,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: size.height * 0.02),

                    Text(
                      '⭐ ${widget.movie.vote_average}',
                      style: TextStyle(fontSize: size.height * 0.02),
                    ),
                    SizedBox(height: size.height * 0.02),
                    DropdownButton<MovieStatus>(
                      value: selectedStatus,
                      items: MovieStatus.values
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(
                                status.name.toUpperCase(),
                                style: TextStyle(
                                  color: status == MovieStatus.pending
                                      ? Colors.red
                                      : status == MovieStatus.watching
                                      ? Colors.orange
                                      : Colors.green,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) =>
                          setState(() => selectedStatus = value),
                    ),

                    SizedBox(height: size.height * 0.02),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(widget.movie.overview),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Container(
                      width: size.width * 0.8,
                      child: Column(
                        children: [
                          Row(
                            children: List.generate(5, (index) {
                              return IconButton(
                                onPressed: () => setState(() {
                                  selectedRating = index + 1;
                                }),

                                icon: Icon(
                                  index + 1 <= (selectedRating ?? 0)
                                      ? Icons.star
                                      : Icons.star_border,
                                  color: index + 1 <= (selectedRating ?? 0)
                                      ? Colors.yellow
                                      : Colors.grey,
                                ),
                              );
                            }),
                          ),
                          SizedBox(height: size.height * 0.02),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [Text('Tu Reseña')],
                          ),
                          SizedBox(height: size.height * 0.02),
                          TextField(
                            controller: reviewController,
                            minLines: 3,
                            maxLines: 5,
                            decoration: InputDecoration(
                              hintText: 'Escribe tu reseña',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          SizedBox(height: size.height * 0.02),
                          ElevatedButton(
                            onPressed: () {
                              if (selectedStatus == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Selecciona un estado'),
                                  ),
                                );
                                return;
                              }
                              context.read<UserMovieCubit>().saveUserMovie(
                                widget.movie.id,
                                selectedStatus!,
                                selectedRating,
                                reviewController.text,
                              );
                            },
                            child: Text('Guardar'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
