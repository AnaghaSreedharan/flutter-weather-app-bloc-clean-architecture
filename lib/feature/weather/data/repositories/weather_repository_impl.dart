import 'package:weather_app/feature/weather/domain/entities/weather.dart';

import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../dataSources/weather_local_datasource.dart';
import '../dataSources/weather_remote_datasource.dart';

class WeatherRepositoryImpl  implements WeatherRepository {
  final WeatherRemoteDatasource weatherRemoteDatasource;
  final WeatherLocalDatasource localDataSource;

  WeatherRepositoryImpl(this.weatherRemoteDatasource,this.localDataSource);

  @override
  Future<Weather> getWeather(String cityName) {
    return weatherRemoteDatasource.getWeather(cityName);
  }

  @override
  Future<List<Forecast>> getForecast(String cityName) async {
    return await weatherRemoteDatasource.getForecast(cityName);
  }

  @override
  Future<List<String>> getSearchHistory() async {
    return await localDataSource.getSearchHistory();
  }

  @override
  Future<void> saveSearch(String cityName) async {
    await localDataSource.saveSearch(cityName);
  }


}