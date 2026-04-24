import 'package:weather_app/feature/weather/domain/entities/weather.dart';

import '../../domain/entities/forecast.dart';
import '../../domain/repositories/weather_repository.dart';
import '../dataSources/weather_local_datasource.dart';
import '../dataSources/weather_remote_datasource.dart';
import '../models/forecast_model.dart';
import '../models/weather_model.dart';

class WeatherRepositoryImpl implements WeatherRepository {
  final WeatherRemoteDatasource weatherRemoteDatasource;
  final WeatherLocalDatasource localDataSource;

  WeatherRepositoryImpl(this.weatherRemoteDatasource, this.localDataSource);

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

  @override
  Future<Weather?> getCachedWeather(String cityName) async {
    return await localDataSource.getCachedWeather(cityName);
  }

  @override
  Future<void> cacheWeather(String cityName, Weather weather) async {
    await localDataSource.cacheWeather(
      cityName,
      WeatherModel(
        cityName: weather.cityName,
        temperature: weather.temperature,
        description: weather.description,
      ),
    );
  }

  @override
  Future<List<Forecast>> getCachedForecast(String cityName) async {
    return await localDataSource.getCachedForecast(cityName);
  }

  @override
  Future<void> cacheForecast(String cityName, List<Forecast> forecasts) async {
    await localDataSource.cacheForecast(
      cityName,
      forecasts.map((f) => ForecastModel(
        date: f.date,
        temperature: f.temperature,
        description: f.description,
      )).toList(),
    );
  }
}
