import 'package:weather_app/feature/favorites/domain/repositories/favorites_repository.dart';

class CheckFavourite {
  final FavouritesRepository favouritesRepository;
  CheckFavourite(this.favouritesRepository);
  Future<bool> call(String cityName) async {
    return await favouritesRepository.isFavourite(cityName);
  }

}