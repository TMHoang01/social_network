part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeState {
  @override
  String toString() => 'HomeInitialState';
}

class HomeLoadingState extends HomeState {
  @override
  String toString() => 'HomeLoadingState';
}

class HomeLoadedState extends HomeState {
  final List<ProductModel>? salesProducts;
  final List<ProductModel>? newProducts;

  HomeLoadedState({this.salesProducts, this.newProducts});

  @override
  String toString() => 'HomeLoadedState';

  @override
  List<Object> get props => [salesProducts!, newProducts!];
}

class HomeErrorState extends HomeState {
  final String error;

  HomeErrorState({required this.error});

  @override
  String toString() => 'HomeErrorState';

  @override
  List<Object> get props => [error];
}
