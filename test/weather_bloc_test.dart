import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_app/feature/weather/domain/entities/weather.dart';
import 'package:weather_app/feature/weather/domain/repositories/weather_repository.dart';
import 'package:weather_app/feature/weather/domain/usecases/get_forecast.dart';
import 'package:weather_app/feature/weather/domain/usecases/get_weather.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_bloc.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_event.dart';
import 'package:weather_app/feature/weather/presentation/bloc/weather_state.dart';
import 'package:mocktail/mocktail.dart';

class MockWeather extends Mock implements GetWeather{}

class MockForecast extends Mock implements GetForecast{}

class MockWeatherRepository extends Mock implements WeatherRepository {}

void main(){
  late MockWeather mockWeather;
  late MockForecast mockForecast;
  late WeatherBloc weatherBloc;
  late MockWeatherRepository mockWeatherRepository;

  // Runs before every test
  setUp((){
    mockWeather = MockWeather();
    mockForecast = MockForecast();
    mockWeatherRepository = MockWeatherRepository();


    when(() => mockWeatherRepository.getSearchHistory())
        .thenAnswer((_) async => []);
    when(() => mockWeatherRepository.saveSearch(any()))
        .thenAnswer((_) async {});


    weatherBloc = WeatherBloc(mockWeather,mockForecast,mockWeatherRepository);
  });

  // Runs after every test — prevents memory leaks
  tearDown((){
    weatherBloc.close();
  });

  const testWeather = Weather(
      cityName: 'London',
      temperature: 20.0,
      description: 'Cloudy');
  
  group('WeatherBloc Tests', () {
    // Test 1 — Initial state
    test('Initial State', () {
      expect(weatherBloc.state, isA<WeatherInitial>());
    });

    // Test 2 — Success case
   blocTest<WeatherBloc, WeatherState>('emits [WeatherLoading, WeatherLoaded] when fetch succeeds',
        build: () {
          when(() => mockWeather('London')).thenAnswer((_) async => testWeather);
          return weatherBloc;
        },
        act: (bloc) => bloc.add(GetWeatherEvent('London')),
        expect: () => [
          isA<WeatherLoading>(),
          isA<WeatherLoaded>().having((state) => state.weather, 'weather', testWeather),
        ]

    );


    // Test 3 — Failure case
    // Test 3 — Failure case
    blocTest<WeatherBloc, WeatherState>(
      'emits [WeatherLoading, WeatherError] when fetch fails',
      build: () {
        when(() => mockWeather('InvalidCity'))
            .thenThrow(Exception('Network error'));
        return weatherBloc;
      },
      act: (bloc) => bloc.add(GetWeatherEvent('InvalidCity')),
      expect: () => [
        isA<WeatherLoading>(),
        isA<WeatherError>(),
      ],
    );

  });


}