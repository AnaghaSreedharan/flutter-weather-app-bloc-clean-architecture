import 'package:weather_app/feature/favorites/domain/repositories/favorites_repository.dart';

import '../entities/favorite.dart';

class GetFavourites {
  final FavouritesRepository favouritesRepository;
  GetFavourites(this.favouritesRepository);
  Future<List<Favourite>> call() async {
    return await favouritesRepository.getFavourites();
  }
}