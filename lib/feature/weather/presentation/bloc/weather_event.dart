import 'package:equatable/equatable.dart';

abstract class WeatherEvent extends Equatable {}

class GetWeatherEvent extends WeatherEvent {
  final String cityName;
  GetWeatherEvent(this.cityName);

  @override
  List<Object> get props => [cityName];
}

class LoadSearchHistoryEvent extends WeatherEvent {
  @override
  List<Object> get props => [];
}
