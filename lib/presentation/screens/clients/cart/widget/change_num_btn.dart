import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';

class ChangeNumButton extends StatelessWidget {
  final Function(int) onNumChange;
  final Function(int)? onRemove;
  ChangeNumButton(
      {super.key, required this.onNumChange, this.onRemove, this.value = 1});
  int value;

  void _increment() {
    onNumChange(value + 1);
  }

  void _decrement() {
    if (value > 1) onNumChange(value - 1);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24.0,
      // width: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          value > 1
              ? IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: value > 1 ? _decrement : null,
                  icon: const Icon(Icons.remove),
                )
              : IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: onRemove != null ? () => onRemove!(value) : null,
                  icon: const Icon(Icons.remove),
                ),
          Text(
            value.toString(),
            style: const TextStyle(fontSize: 16.0),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: _increment,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}

class ButtonAddCart extends StatelessWidget {
  final CartItem item;
  const ButtonAddCart({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    return ChangeNumButton(
      onNumChange: (value) => {
        context.read<CartBloc>().add(
              ChangeItemQuantity(
                cartId:
                    (context.read<CartBloc>().state as CartLoadedState).cart.id,
                productId: item.productId,
                quantity: value,
              ),
            ),
      },
      onRemove: (value) => {
        _dialogBuilder(context),
      },
      value: item.quantity,
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          // title: const Text('Basic dialog title'),
          content: const Text(
            'Bạn có chắc chắn muốn xóa sản phẩm này khỏi giỏ hàng?',
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Không'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Đồng ý'),
              onPressed: () async {
                context
                    .read<CartBloc>()
                    .add(RemoveItemCart(productId: item.productId));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
