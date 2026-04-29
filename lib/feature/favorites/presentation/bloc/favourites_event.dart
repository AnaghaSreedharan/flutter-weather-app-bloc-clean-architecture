import 'package:equatable/equatable.dart';

abstract class FavouritesEvent  extends Equatable{

}

class LoadFavouritesEvent extends FavouritesEvent {
  @override
  List<Object?> get props => [];

}

class AddFavouriteEvent extends FavouritesEvent {
  final String cityName;
  AddFavouriteEvent(this.cityName);
  @override
  List<Object?> get props => [cityName];
}

class RemoveFavouriteEvent extends FavouritesEvent {
  final String cityName;
  RemoveFavouriteEvent(this.cityName);
  @override
  List<Object?> get props => [cityName];
}

class CheckFavouriteEvent extends FavouritesEvent {
  final String cityName;
  CheckFavouriteEvent(this.cityName);
  @override
  List<Object?> get props => [cityName];
}
