import 'package:weather_app/feature/weather/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Weather> getWeather(String cityName);
}