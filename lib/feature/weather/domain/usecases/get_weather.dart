import 'package:weather_app/feature/weather/domain/repositories/weather_repository.dart';

import '../entities/weather.dart';

class GetWeather {
  final WeatherRepository weatherRepository;

  GetWeather(this.weatherRepository);

  Future<Weather> call(String cityName) async {
    return await weatherRepository.getWeather(cityName);
  }
}
