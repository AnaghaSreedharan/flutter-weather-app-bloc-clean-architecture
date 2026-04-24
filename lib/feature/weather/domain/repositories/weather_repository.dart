import 'package:weather_app/feature/weather/domain/entities/weather.dart';

import '../entities/forecast.dart';


abstract class WeatherRepository {
  Future<Weather> getWeather(String cityName);
  Future<List<Forecast>> getForecast(String cityName);
  Future<List<String>> getSearchHistory();
  Future<void> saveSearch(String cityName);

  Future<Weather?> getCachedWeather(String cityName);
  Future<void> cacheWeather(String cityName, Weather weather);
  Future<List<Forecast>> getCachedForecast(String cityName);
  Future<void> cacheForecast(String cityName, List<Forecast> forecasts);
}