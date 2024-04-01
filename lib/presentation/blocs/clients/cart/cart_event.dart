part of 'cart_bloc.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class GetCart extends CartEvent {}

class AddItemCart extends CartEvent {
  final ProductModel item;

  AddItemCart({required this.item});

  @override
  List<Object> get props => [item];
}

class RemoveItemCart extends CartEvent {
  final String productId;

  const RemoveItemCart({required this.productId});

  @override
  List<Object> get props => [productId];
}

class ChangeItemQuantity extends CartEvent {
  final String cartId;
  final String productId;
  final int quantity;

  const ChangeItemQuantity(
      {required this.cartId, required this.productId, required this.quantity});

  @override
  List<Object> get props => [productId, quantity];
}

class ClearCart extends CartEvent {}
