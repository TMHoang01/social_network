import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/repository/ecom/product_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final ProductRepository productRepository;
  HomeBloc(this.productRepository) : super(HomeInitialState()) {
    on<HomeEvent>((event, emit) {});
    on<HomeLoadEvent>(_homeLoadEvent);
  }

  FutureOr<void> _homeLoadEvent(
      HomeLoadEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final salesProducts = await productRepository.getAll();
      final newProducts = await productRepository.getAll();
      emit(HomeLoadedState(
          salesProducts: salesProducts, newProducts: newProducts));
    } catch (e) {
      emit(HomeErrorState(error: e.toString()));
    }
  }
}
