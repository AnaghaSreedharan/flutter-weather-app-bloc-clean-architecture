import 'package:equatable/equatable.dart';

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
  WeatherLoaded(this.weather, this.searchHistory,);

  @override
  List<Object> get props => [weather, searchHistory];
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