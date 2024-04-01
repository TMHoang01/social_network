part of 'cart_bloc.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object> get props => [];
}

class CartInitial extends CartState {}

class CartLoadedState extends CartState {
  CartModel cart;

  CartLoadedState({required this.cart});

  @override
  List<Object> get props => [cart.items];

  CartLoadedState copyWith({List<CartItem>? items, double? totalPrice}) {
    return CartLoadedState(
      cart: cart.copyWith(
        items: items ?? cart.items,
        total: totalPrice ?? cart.total,
        createdAt: cart.createdAt,
        status: cart.status,
        userId: cart.userId,
      ),
    );
  }
}

class CartUpdatingItemState extends CartLoadedState {
  CartUpdatingItemState({required CartModel cart}) : super(cart: cart);

  @override
  List<Object> get props => [cart.items];
}

class CartUpadteErrorState extends CartLoadedState {
  final String message;

  CartUpadteErrorState({required CartModel cart, required this.message})
      : super(cart: cart);

  @override
  List<Object> get props => [cart.items, message];
}

class CartError extends CartState {
  final String message;

  const CartError(this.message);

  @override
  List<Object> get props => [message];
}
