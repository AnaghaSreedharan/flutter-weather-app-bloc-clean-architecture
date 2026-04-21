import 'dart:convert';

import 'package:weather_app/feature/weather/data/models/weather_model.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRemoteDatasource {
  Future<WeatherModel> getWeather(String cityName);
}

class WeatherRemoteDatasourceImpl implements WeatherRemoteDatasource {
  final http.Client httpClient;
  static const apiKey = 'a4583cd702cbc95f6babd3e40c689dc5';
  WeatherRemoteDatasourceImpl(this.httpClient);

  @override
  Future<WeatherModel> getWeather(String cityName) async {
    final response = await httpClient.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey&units=metric',
    ));
    if (response.statusCode == 200) {
      return WeatherModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }


}