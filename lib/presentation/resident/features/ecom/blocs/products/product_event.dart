part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class CreateProductEvent extends ProductEvent {
  final String name;
  final String description;
  final double price;
  final File? image;
  final String category;

  const CreateProductEvent(
      this.name, this.description, this.price, this.image, this.category);
}

class FetchProductsEvent extends ProductEvent {}

class ProductDetailEvent extends ProductEvent {
  final String id;

  const ProductDetailEvent(this.id);
}
