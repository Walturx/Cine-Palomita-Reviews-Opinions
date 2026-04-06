import 'package:flutter_repaso/main.dart';

class Profilerepository {
  Future<Map<String, dynamic>> getProfile(String userId) async {
    return await supabase.from('profiles').select().eq('id', userId).single();
  }

  Future<List<Map<String, dynamic>>> getUserMovies(String userId) async {
    return await supabase.from('user_movies').select().eq('user_id', userId);
  }

  Future<void> updateAvatar(String userId, String avatarUrl) async {
    return await supabase
        .from('profiles')
        .update({'avatar_url': avatarUrl})
        .eq('id', userId);
  }
}
