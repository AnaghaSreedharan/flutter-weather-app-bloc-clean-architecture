import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../favorites/presentation/bloc/favourite_state.dart';
import '../../../favorites/presentation/bloc/favourites_bloc.dart';
import '../../../favorites/presentation/bloc/favourites_event.dart';
import '../../domain/entities/forecast.dart';
import '../../domain/entities/weather.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import '../bloc/weather_state.dart';
class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: const Text('Weather App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Search Bar
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        hintText: 'Enter city name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      // Fires event to BLoC
                      context.read<WeatherBloc>().add(
                        GetWeatherEvent(_controller.text),
                      );

                      // Check if this city is favourite
                      context.read<FavouritesBloc>().add(
                        CheckFavouriteEvent(_controller.text),
                      );
                    },
                    child: const Text('Search'),
                  ),
                ],
              ),
          
              const SizedBox(height: 32),
          
              BlocListener<WeatherBloc, WeatherState>(listener: (context, state){},
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherInitial) {
                    return const Text('Search for a city');
                  }
                  if (state is WeatherLoading) {
                    return const CircularProgressIndicator();
                  }
                  if (state is WeatherLoaded) {
                    return Column(
                      children: [
                        // 👇 Show banner if data is from cache
                        if (state.isFromCache)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            color: Colors.orange.shade100,
                            child: const Text(
                              '⚡ Showing cached data — updating...',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        BlocBuilder<FavouritesBloc, FavouriteState>(builder: (context, favState) {
                          final isFav = favState is FavouriteLoaded
                              ? favState.isFavourite
                              : false;
                          return IconButton(
                            icon: Icon(
                              isFav ? Icons.favorite : Icons.favorite_border,
                              color: Colors.red,
                              size: 32,
                            ),
                            onPressed: () {
                              if (isFav) {
                                context.read<FavouritesBloc>().add(
                                  RemoveFavouriteEvent(state.weather.cityName),
                                );
                              } else {
                                context.read<FavouritesBloc>().add(
                                  AddFavouriteEvent(state.weather.cityName),
                                );
                              }
                            },
                          );
                        }),

                        const SizedBox(height: 16),
                        _WeatherDisplay(weather: state.weather),
                        const SizedBox(height: 24),

                        if (state.forecast.isNotEmpty) ...[
                          _ForecastDisplay(forecasts: state.forecast),
                          const SizedBox(height: 24),
                        ],

                        _SearchHistory(history: state.searchHistory),
                      ],
                    );
                  }
                  if (state is SearchHistoryLoaded) {
                    return _SearchHistory(history: state.history);
                  }
                  if (state is WeatherError) {
                    return Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    );
                  }
                  return const SizedBox();
                },
              ) ,)
          
              // BLoC State Handler
          
            ],
          ),
        ),
      ),
    );
  }
}
class _SearchHistory extends StatelessWidget {
  final List<String> history;

  const _SearchHistory({required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Searches',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...history.map(
              (city) => ListTile(
            leading: const Icon(Icons.history),
            title: Text(city),
            onTap: () {
              // Tapping history item loads weather directly
              context.read<WeatherBloc>().add(GetWeatherEvent(city));
            },
          ),
        ),
      ],
    );
  }
}

class _WeatherDisplay extends StatelessWidget {
  final Weather weather;

  const _WeatherDisplay({required this.weather});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '${weather.temperature}°C',
          style: const TextStyle(fontSize: 48),
        ),
        const SizedBox(height: 8),
        Text(
          weather.description,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}

// Add this new widget at the bottom of the file
class _ForecastDisplay extends StatelessWidget {
  final List<Forecast> forecasts;

  const _ForecastDisplay({required this.forecasts});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '5 Day Forecast',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        ...forecasts.map(
              (forecast) => Card(
            child: ListTile(
              title: Text(forecast.date),
              subtitle: Text(forecast.description),
              trailing: Text(
                '${forecast.temperature}°C',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
