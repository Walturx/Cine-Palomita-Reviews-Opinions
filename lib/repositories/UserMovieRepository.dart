import 'package:flutter_repaso/main.dart';

class Usermovierepository {
  Future<Map<String, dynamic>?> getUserMovie(
    String movieId,
    String userId,
  ) async {
    return await supabase
        .from('user_movies')
        .select()
        .eq('tmdb_id', int.parse(movieId))
        .eq('user_id', userId)
        .maybeSingle();
  }

  Future<void> saveUserMovie(
    String movieId,
    String userId,
    String status,
    int? rating,
    String? review,
  ) async {
    await supabase.from('user_movies').upsert({
      'user_id': userId,
      'tmdb_id': int.parse(movieId),
      'status': status,
      'rating': rating,
      'review': review,
    }, onConflict: 'user_id,tmdb_id');
  }
}
