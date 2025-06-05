import "package:shared_preferences/shared_preferences.dart";

class FavoriteManager {
  static const _key = "favorite_song_ids";

  static Future<List<int>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key)?.map(int.parse).toList() ?? [];
  }

  static Future<void> addFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    if (!favorites.contains(id)) {
      favorites.add(id);
      prefs.setStringList(_key, favorites.map((e) => e.toString()).toList());
    }
  }

  static Future<void> removeFavorite(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavorites();
    favorites.remove(id);
    prefs.setStringList(_key, favorites.map((e) => e.toString()).toList());
  }
}
