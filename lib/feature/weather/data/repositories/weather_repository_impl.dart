import 'package:weather_app/feature/weather/domain/entities/weather.dart';

import '../../domain/repositories/weather_repository.dart';
import '../dataSources/weather_remote_datasource.dart';

class WeatherRepositoryImpl  implements WeatherRepository {
  final WeatherRemoteDatasource weatherRemoteDatasource;
  WeatherRepositoryImpl(this.weatherRemoteDatasource);

  @override
  Future<Weather> getWeather(String cityName) {
    return weatherRemoteDatasource.getWeather(cityName);
  }
}