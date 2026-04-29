import 'package:equatable/equatable.dart';

import '../../domain/entities/favorite.dart';

abstract class FavouriteState extends Equatable {

  @override
  List<Object?> get props => [];
}

class FavouriteInitial extends FavouriteState {

}

class FavouriteLoading extends FavouriteState {

}

class FavouriteLoaded extends FavouriteState {
  final List<Favourite> favourites;
  final bool isFavourite;
  FavouriteLoaded({required this.favourites, this.isFavourite = false});
  @override
  List<Object?> get props => [favourites,isFavourite];
}

class FavouriteError extends FavouriteState {
  final String message;
  FavouriteError(this.message);
  @override
  List<Object?> get props => [message];
}