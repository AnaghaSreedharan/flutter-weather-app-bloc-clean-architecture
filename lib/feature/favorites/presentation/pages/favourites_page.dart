import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/feature/favorites/presentation/bloc/favourite_state.dart';
import '../bloc/favourites_bloc.dart';
import '../bloc/favourites_event.dart';
import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../../weather/presentation/bloc/weather_event.dart';

class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('❤️ Favourites')),
      body: BlocBuilder<FavouritesBloc, FavouriteState>(
        builder: (context, state) {
          if (state is FavouriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FavouriteLoaded) {
            if (state.favourites.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No favourites yet!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Search for a city and tap ❤️ to save it',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            return ListView.builder(
              itemCount: state.favourites.length,
              itemBuilder: (context, index) {
                final favourite = state.favourites[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    title: Text(
                      favourite.cityName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // Tap city → load weather and switch to weather tab
                    onTap: () {
                      context.read<WeatherBloc>().add(
                        GetWeatherEvent(favourite.cityName),
                      );
                      // Switch to weather tab
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    // Remove from favourites
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () {
                        context.read<FavouritesBloc>().add(
                          RemoveFavouriteEvent(favourite.cityName),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          }
          if (state is FavouriteError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox();
        },
      ),
    );
  }
}