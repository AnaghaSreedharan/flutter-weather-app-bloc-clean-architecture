import 'package:weather_app/feature/favorites/data/datasources/favourites_local_datasource.dart';
import 'package:weather_app/feature/favorites/domain/repositories/favorites_repository.dart';

import '../../domain/entities/favorite.dart';

class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesLocalDatasource localDataSource;
  FavouritesRepositoryImpl(this.localDataSource);

  @override
  Future<List<Favourite>> getFavourites() async {
    return await localDataSource.getFavourites();
  }

  @override
  Future<void> addFavourite(String cityName) async {
    await localDataSource.addFavourite(cityName);
  }

  @override
  Future<void> removeFavourite(String cityName) async {
    await localDataSource.removeFavourite(cityName);
  }

  @override
  Future<bool> isFavourite(String cityName) async {
    return await localDataSource.isFavourite(cityName);
  }


}