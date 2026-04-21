import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_state.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_weather.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  final WeatherRepository repository;

  WeatherBloc(this.getWeather,this.repository): super(WeatherInitial()){
    on<GetWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeather(event.cityName);
        await repository.saveSearch(event.cityName);
        final history = await repository.getSearchHistory();
        emit(WeatherLoaded(weather,history));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });
    on<LoadSearchHistoryEvent>((event, emit) async {
      final history = await repository.getSearchHistory();
      emit(SearchHistoryLoaded(history));
    });
  }
}