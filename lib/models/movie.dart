class Movie {
  final String id;
  final String title;
  final List<int> genre_ids;
  final double vote_average;
  final String poster_path;
  final MovieStatus? status;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.genre_ids,
    required this.vote_average,
    required this.poster_path,
    this.status,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'].toString(),
      title: json['title'],
      genre_ids: json['genre_ids'].cast<int>(),
      vote_average: json['vote_average'].toDouble(),
      poster_path: json['poster_path'] != null
          ? 'https://image.tmdb.org/t/p/w500${json['poster_path']}'
          : 'https://picsum.photos/200/300',
      status: MovieStatus.pending,
      overview: json['overview'],
    );
  }
}

enum MovieStatus { pending, watching, watched }
