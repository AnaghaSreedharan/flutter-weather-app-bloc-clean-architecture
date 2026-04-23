import 'package:weather_app/feature/weather/domain/repositories/weather_repository.dart';

import '../entities/forecast.dart';

class GetForecast {
  WeatherRepository weatherRepository;

  GetForecast(this.weatherRepository);

  Future<List<Forecast>> call(String cityName) async {
    return await weatherRepository.getForecast(cityName);
  }

}