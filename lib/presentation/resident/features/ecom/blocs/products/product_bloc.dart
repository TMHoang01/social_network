import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/repository/ecom/product_repository.dart';
import 'package:social_network/utils/logger.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  late List<ProductModel> listProducts;

  ProductBloc({required this.productRepository}) : super(ProductInitial()) {
    on<ProductEvent>((event, emit) {});

    on<FetchProductsEvent>(_fetchProducts);
    on<ProductDetailEvent>(_productDetail);
  }

  FutureOr<void> _fetchProducts(
      FetchProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      listProducts = await productRepository.getAll();
      emit(ProductSuccess(listProducts));
    } catch (e) {
      logger.e(e);
      emit(ProductError(e.toString()));
    }
  }

  FutureOr<ProductModel> _productDetail(
      ProductDetailEvent event, Emitter<ProductState> emit) async {
    return listProducts.firstWhere((element) => element.id == event.id);
  }
}
