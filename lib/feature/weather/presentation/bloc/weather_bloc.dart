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

        final history = await repository.getSearchHistory();

        final cachedWeather = await repository.getCachedWeather(event.cityName);
        final cachedForecast = await repository.getCachedForecast(event.cityName);

        if(cachedWeather != null){
          // Show cached data immediately — user sees something instantly
          emit(WeatherLoaded(
            weather: cachedWeather,
            searchHistory: history,
            forecast: cachedForecast,
            isFromCache: true, // 👈 tell UI this is cached
          ));
        }

        // Step 2 — Fetch fresh data from API
        try {
          final weather = await getWeather(event.cityName);
          await repository.saveSearch(event.cityName);
          await repository.cacheWeather(event.cityName, weather); // 👈 cache it

          final updatedHistory = await repository.getSearchHistory();

          // Emit with empty forecast first
          emit(WeatherLoaded(
            weather: weather,
            searchHistory: updatedHistory,
            forecast: cachedForecast,
            isFromCache: false, // 👈 fresh data
          ));

          // Fetch and cache forecast
          final forecasts = await getForecast(event.cityName);
          await repository.cacheForecast(event.cityName, forecasts); // 👈 cache it

          // Emit with everything
          emit(WeatherLoaded(
            weather: weather,
            searchHistory: updatedHistory,
            forecast: forecasts,
            isFromCache: false,
          ));

        } catch (e) {
          // If API fails but we have cache — don't show error!
          if (cachedWeather == null) {
            emit(WeatherError('No internet connection and no cached data'));
          }
          // If cache exists, user already sees cached data — silently fail
        }
    });

    on<LoadSearchHistoryEvent>((event, emit) async {
      final history = await repository.getSearchHistory();
      emit(SearchHistoryLoaded(history));
    });
  }
}