import 'package:shared_preferences/shared_preferences.dart';


abstract class WeatherLocalDatasource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearch(String cityName);
}

class WeatherLocalDataSourceImpl implements WeatherLocalDatasource {
  static const historyKey = 'search_history';
  final SharedPreferences prefs;

  WeatherLocalDataSourceImpl(this.prefs);

  @override
  Future<List<String>> getSearchHistory() async {
    return prefs.getStringList(historyKey) ?? [];
  }

  @override
  Future<void> saveSearch(String cityName) async {
    final history = prefs.getStringList(historyKey) ?? [];

    // Remove if already exists — avoid duplicates
    history.remove(cityName);

    // Add to beginning of list — most recent first
    history.insert(0, cityName);

    // Keep only last 5 searches
    if (history.length > 5) {
      history.removeLast();
    }

    await prefs.setStringList(historyKey, history);
  }
}