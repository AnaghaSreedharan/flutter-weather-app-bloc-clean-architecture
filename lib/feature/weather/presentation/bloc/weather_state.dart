import 'package:equatable/equatable.dart';

import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';

abstract class WeatherState extends Equatable {
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final Weather weather;
  final List<String> searchHistory;
  final List<Forecast> forecast;
  WeatherLoaded({required this.weather,required this.forecast, required this.searchHistory,});

  @override
  List<Object> get props => [weather,forecast, searchHistory];
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);

  @override
  List<Object> get props => [message];
}

class SearchHistoryLoaded extends WeatherState {
  final List<String> history;
  SearchHistoryLoaded(this.history);

  @override
  List<Object> get props => [history];
}