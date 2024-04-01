part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeLoadEvent extends HomeEvent {
  @override
  String toString() => 'Home is Loaded';
}

class HomeAddToFavoriteEvent extends HomeEvent {
  final bool? isFavorite;
  final ProductModel? product;

  const HomeAddToFavoriteEvent({this.isFavorite, this.product});

  @override
  List<Object> get props => [isFavorite!, product!];
}
