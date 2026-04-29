import '../entities/favorite.dart';

abstract class FavouritesRepository {
  Future<List<Favourite>> getFavourites();
  Future<void> addFavourite(String cityName);
  Future<void> removeFavourite(String cityName);
  Future<bool> isFavourite(String cityName);
}