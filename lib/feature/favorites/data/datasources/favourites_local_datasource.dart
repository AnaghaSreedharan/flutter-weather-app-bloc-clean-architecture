import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/entities/favorite.dart';

abstract class FavouritesLocalDatasource {
  Future<List<Favourite>> getFavourites();
  Future<void> addFavourite(String cityName);
  Future<void> removeFavourite(String cityName);
  Future<bool> isFavourite(String cityName);
}

class FavouritesLocalDatasourceImpl implements FavouritesLocalDatasource {
  static const favouritesKey = 'favourites';
  final SharedPreferences prefs;
  FavouritesLocalDatasourceImpl(this.prefs);

  @override
  Future<List<Favourite>> getFavourites() async {
    final list = prefs.getStringList(favouritesKey) ?? [];
    return list.map((city) => Favourite(cityName: city)).toList();
  }

  @override
  Future<void> addFavourite(String cityName) async {
    final list = prefs.getStringList(favouritesKey) ?? [];
    if (!list.contains(cityName)) {
      list.add(cityName);
      await prefs.setStringList(favouritesKey, list);
    }
  }

  @override
  Future<void> removeFavourite(String cityName) async {
    final list = prefs.getStringList(favouritesKey) ?? [];
    list.remove(cityName);
    await prefs.setStringList(favouritesKey, list);
  }

  @override
  Future<bool> isFavourite(String cityName) async {
    final list = prefs.getStringList(favouritesKey) ?? [];
    return list.contains(cityName);
  }
}