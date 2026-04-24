import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/forecast_model.dart';
import '../models/weather_model.dart';


abstract class WeatherLocalDatasource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearch(String cityName);
  Future<WeatherModel?> getCachedWeather(String cityName);
  Future<void> cacheWeather(String cityName, WeatherModel weather);
  Future<List<ForecastModel>> getCachedForecast(String cityName);
  Future<void> cacheForecast(String cityName, List<ForecastModel> forecasts);
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


  @override
  Future<WeatherModel?> getCachedWeather(String cityName) async {
    final jsonString = prefs.getString('weather_$cityName');
    if (jsonString == null) return null;
    return WeatherModel.fromJson(jsonDecode(jsonString));
  }

  @override
  Future<void> cacheWeather(String cityName, WeatherModel weather) async {
    await prefs.setString(
      'weather_$cityName',
      jsonEncode({
        'name': weather.cityName,
        'main': {'temp': weather.temperature},
        'weather': [
          {'description': weather.description}
        ],
      }),
    );
  }

  @override
  Future<List<ForecastModel>> getCachedForecast(String cityName) async {
    final jsonString = prefs.getString('forecast_$cityName');
    if (jsonString == null) return [];
    final List list = jsonDecode(jsonString);
    return list.map((e) => ForecastModel.fromJson(e)).toList();
  }

  @override
  Future<void> cacheForecast(
      String cityName, List<ForecastModel> forecasts) async {
    final list = forecasts
        .map((f) => {
      'dt_txt': f.date,
      'main': {'temp': f.temperature},
      'weather': [
        {'description': f.description}
      ],
    })
        .toList();
    await prefs.setString('forecast_$cityName', jsonEncode(list));
  }

}