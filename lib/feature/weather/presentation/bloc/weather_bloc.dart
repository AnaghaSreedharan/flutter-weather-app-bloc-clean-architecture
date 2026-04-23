import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_state.dart';
import '../../domain/repositories/weather_repository.dart';
import '../../domain/usecases/get_forecast.dart';
import '../../domain/usecases/get_weather.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetWeather getWeather;
  final GetForecast getForecast;
  final WeatherRepository repository;

  WeatherBloc(this.getWeather,this.getForecast,this.repository): super(WeatherInitial()){
    on<GetWeatherEvent>((event, emit) async {
      emit(WeatherLoading());
      try {
        final weather = await getWeather(event.cityName);
        await repository.saveSearch(event.cityName);
        final history = await repository.getSearchHistory();
        emit(WeatherLoaded(weather: weather,forecast: const [],searchHistory: history));
        // Fetch forecast
        final forecasts = await getForecast(event.cityName);

        // Emit again with forecast included
        emit(WeatherLoaded(
         weather:  weather,
         forecast:   forecasts,
         searchHistory:  history,
        ));
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