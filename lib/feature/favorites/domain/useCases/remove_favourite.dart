import 'package:weather_app/feature/favorites/domain/repositories/favorites_repository.dart';

class RemoveFavourite {
  final FavouritesRepository favouritesRepository;
  RemoveFavourite(this.favouritesRepository);
  Future<void> call(String cityName) async {
    await favouritesRepository.removeFavourite(cityName);
  }
}