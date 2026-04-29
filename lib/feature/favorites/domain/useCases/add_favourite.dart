import 'package:weather_app/feature/favorites/domain/repositories/favorites_repository.dart';

class AddFavourite {
  final FavouritesRepository favouritesRepository;
  AddFavourite(this.favouritesRepository);
  Future<void> call(String cityName) async {
    await favouritesRepository.addFavourite(cityName);
  }
}