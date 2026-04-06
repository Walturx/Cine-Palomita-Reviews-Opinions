import 'package:flutter/material.dart';
import 'package:flutter_repaso/models/movie.dart';
import 'package:go_router/go_router.dart';

class MovieCards extends StatelessWidget {
  final Movie movies;
  final MovieStatus? status;

  const MovieCards({super.key, required this.movies, this.status});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => context.push('/movie', extra: movies),
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.02,
          vertical: size.height * 0.01,
        ),
        child: Row(
          children: [
            Image.network(
              movies.poster_path,
              width: size.width * 0.55,
              height: size.height * 0.5,
              fit: BoxFit.cover,
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(size.width * 0.04),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movies.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    Text(
                      movies.genre_ids.join(', '),
                      style: TextStyle(color: Colors.grey),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow),
                        Text(movies.vote_average.toString()),
                      ],
                    ),
                    Text(
                      status != null ? status!.name.toUpperCase() : 'No status',
                      style: TextStyle(
                        color: status == null
                            ? Colors.grey
                            : status == MovieStatus.pending
                            ? Colors.red
                            : status == MovieStatus.watching
                            ? Colors.orange
                            : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
