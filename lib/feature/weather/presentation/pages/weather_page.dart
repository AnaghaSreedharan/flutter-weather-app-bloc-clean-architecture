import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
                  },
                  child: const Text('Search'),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // BLoC State Handler
            BlocBuilder<WeatherBloc, WeatherState>(
              builder: (context, state) {
                if (state is WeatherInitial) {
                  return const Text('Search for a city');
                }
                if (state is WeatherLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is WeatherLoaded) {
                  return Column(                                    // 👈 only this block changed
                    children: [
                      _WeatherDisplay(weather: state.weather),
                      const SizedBox(height: 24),
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
            ),
          ],
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
