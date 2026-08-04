import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _favoritesKey = 'toolnova_favorites';
  static const _recentKey = 'toolnova_recent';

  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  Future<Set<String>> loadFavorites() async {
    final values = await _prefs.getStringList(_favoritesKey) ?? <String>[];
    return values.toSet();
  }

  Future<void> saveFavorites(Set<String> ids) async {
    await _prefs.setStringList(_favoritesKey, ids.toList(growable: false));
  }

  Future<List<String>> loadRecent() async {
    return await _prefs.getStringList(_recentKey) ?? <String>[];
  }

  Future<void> addRecent(String id) async {
    final current = await loadRecent();
    current.remove(id);
    current.insert(0, id);
    if (current.length > 20) {
      current.removeRange(20, current.length);
    }
    await _prefs.setStringList(_recentKey, current);
  }

  Future<void> clearRecent() async {
    await _prefs.remove(_recentKey);
  }
}
