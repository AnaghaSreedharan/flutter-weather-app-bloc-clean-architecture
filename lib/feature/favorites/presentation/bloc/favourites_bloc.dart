import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/feature/favorites/domain/useCases/add_favourite.dart';
import 'package:weather_app/feature/favorites/domain/useCases/check_favourite.dart';
import 'package:weather_app/feature/favorites/presentation/bloc/favourite_state.dart';

import '../../domain/useCases/get_favourites.dart';
import '../../domain/useCases/remove_favourite.dart';
import 'favourites_event.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouriteState> {
  final GetFavourites getFavourites;
  final AddFavourite addFavourite;
  final RemoveFavourite removeFavourite;
  final CheckFavourite checkFavourite;
  FavouritesBloc(  {required this.getFavourites, required this.addFavourite, required this.removeFavourite, required this.checkFavourite}) : super(FavouriteInitial()){
    on<LoadFavouritesEvent>((event, emit) async {
      emit(FavouriteLoading());
      try {
        final favourites = await getFavourites();
        emit(FavouriteLoaded(favourites: favourites));
      } catch (e) {
        emit(FavouriteError('Could not load favourites'));
      }
    });

    on<AddFavouriteEvent>((event, emit) async {
      try {
        await addFavourite(event.cityName);
        final favourites = await getFavourites();
        emit(FavouriteLoaded(favourites: favourites,isFavourite: true));
      } catch (e) {
        emit(FavouriteError('Could not add favourite'));
      }

    });

    on<RemoveFavouriteEvent>((event, emit) async {
      try {
        await removeFavourite(event.cityName);
        final favourites = await getFavourites();
        emit(FavouriteLoaded(favourites: favourites,isFavourite: false));
      } catch (e) {
        emit(FavouriteError('Could not remove favourite'));
      }
    });

    on<CheckFavouriteEvent>((event, emit) async {
      try {
        final favourites = await getFavourites();
        final isFav = await checkFavourite(event.cityName);
        emit(FavouriteLoaded(
          favourites: favourites,
          isFavourite: isFav,
        ));
      } catch (e) {
        emit(FavouriteError('Could not check favourite'));
      }
    });
  }

}