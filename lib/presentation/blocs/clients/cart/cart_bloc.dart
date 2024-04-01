import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/domain/models/ecom/cart.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/repository/ecom/cart_repository.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/logger.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartRepository cartRepository;
  CartBloc({required this.cartRepository}) : super(CartInitial()) {
    on<GetCart>((event, emit) => _onLoad(event, emit));
    on<AddItemCart>((event, emit) => _onAddItem(event, emit));
    on<RemoveItemCart>((event, emit) => _onRemoveItem(event, emit));
    on<ChangeItemQuantity>((event, emit) => _onChangeItemQuantity(event, emit));

    on<ClearCart>((event, emit) => _onClearCart(event, emit));
  }

  _onLoad(GetCart event, Emitter<CartState> emit) async {
    try {
      emit(CartInitial());
      final CartModel cart = await _getCart();
      // check not null
      logger.i(cart);
      emit(CartLoadedState(cart: cart.copyWith()));
    } catch (e) {
      logger.e(e);
      emit(CartError(e.toString()));
    }
  }

  _onAddItem(AddItemCart event, Emitter<CartState> emit) async {
    try {
      ProductModel product = event.item;
      CartModel? cart = await _getCart();
      logger.i(cart);
      List<CartItem>? listItem = cart.items;
      emit(CartUpdatingItemState(cart: cart));

      if (listItem.isEmpty) {
        final cartItem = CartItem(
          productId: product.id ?? '',
          quantity: 1,
          price: product.price ?? 0.0,
          title: product.name,
          imageUrl: product.imageUrl,
        );
        await cartRepository.addCartItem(id: cart.id, cartItem: cartItem);
        listItem.add(cartItem);
        emit(CartLoadedState(cart: cart.copyWith(items: listItem)));
      } else {
        int index = listItem
            .indexWhere((element) => element.productId == event.item.id);
        // if(index != -1)
        if (index != -1) {
          listItem[index] =
              listItem[index].copyWith(quantity: listItem[index].quantity + 1);
          await cartRepository.update(id: cart.id, cartItems: listItem);
          emit(CartLoadedState(cart: cart.copyWith(items: listItem)));
        } else {
          final item = event.item;
          listItem.add(CartItem(
            productId: item.id ?? '',
            quantity: 1,
            price: item.price ?? 0.0,
            title: item.name,
            imageUrl: item.imageUrl,
          ));
          await cartRepository.addCartItem(
              id: cart.id, cartItem: listItem.last);
          emit(
              CartLoadedState(cart: cart.copyWith(items: listItem)).copyWith());
        }
      }
    } catch (e) {
      logger.e(e);
      emit(CartError(e.toString()));
    }
  }

  _onRemoveItem(RemoveItemCart event, Emitter<CartState> emit) async {
    try {
      CartModel cart = await _getCart();
      List<CartItem> listItem = cart.items;
      int index = listItem
          .indexWhere((element) => element.productId == event.productId);

      emit(CartUpdatingItemState(cart: cart));
      listItem.removeAt(index);
      await cartRepository.update(id: cart.id, cartItems: listItem);

      emit(CartLoadedState(cart: cart.copyWith(items: listItem)));
    } catch (e) {
      logger.e(e);
      emit(CartError(e.toString()));
    }
  }

  _onChangeItemQuantity(
      ChangeItemQuantity event, Emitter<CartState> emit) async {
    try {
      CartModel cart = await _getCart();
      List<CartItem> listItem = cart.items;
      int index = listItem
          .indexWhere((element) => element.productId == event.productId);

      emit(CartUpdatingItemState(cart: cart));
      listItem[index] = listItem[index].copyWith(quantity: event.quantity);
      await cartRepository.update(id: cart.id, cartItems: listItem);

      emit(CartLoadedState(cart: cart.copyWith(items: listItem)));
    } catch (e) {
      logger.e(e);
      emit(CartError(e.toString()));
    }
  }

  _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    try {
      CartModel cart = await _getCart();
      emit(CartUpdatingItemState(cart: cart));
      await cartRepository.update(id: cart.id, cartItems: []);
      emit(CartLoadedState(cart: cart.copyWith(items: [])));
    } catch (e) {
      logger.e(e);
      emit(CartError(e.toString()));
    }
  }

  Future<CartModel> _getCart() async {
    final state = this.state;
    CartModel? cart;
    final userId = firebaseAuth.currentUser!.uid;
    if (state is CartLoadedState && state.cart.userId == userId) {
      cart = state.cart;
    } else {
      logger.i(firebaseAuth.currentUser!.uid);
      cart = await cartRepository.get(userdId: firebaseAuth.currentUser!.uid);
    }
    return cart;
  }
}
