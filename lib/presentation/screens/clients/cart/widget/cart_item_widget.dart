import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';
import 'package:social_network/presentation/screens/clients/cart/widget/change_num_btn.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';

class CartItemWidget extends StatelessWidget {
  final CartItem item;
  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        CartBloc cartBloc = context.watch<CartBloc>();

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          // height: 100.0,
          child: Row(
            children: [
              SizedBox(
                width: 80.0,
                height: 80.0,
                child: CustomImageView(
                  url: item.imageUrl,
                  width: 80.0,
                  height: 80.0,
                ),
              ),
              const SizedBox(width: 16.0),

              // Product details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        item.title ?? '',
                        style: const TextStyle(
                            fontSize: 16.0, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '₫ ${item.price}',
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        ChangeNumButton(
                          onNumChange: (value) => {
                            cartBloc
                              ..add(
                                ChangeItemQuantity(
                                  cartId: (cartBloc.state as CartLoadedState)
                                      .cart
                                      .id,
                                  productId: item.productId,
                                  quantity: value,
                                ),
                              ),
                          },
                          onRemove: (value) => {
                            _dialogBuilder(context),
                          },
                          value: item.quantity,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Thông báo'),
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
                navService.pop(context);
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
                navService.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
