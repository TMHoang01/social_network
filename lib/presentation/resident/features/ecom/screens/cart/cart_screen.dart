import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/cart/cart_bloc.dart';
import 'package:social_network/presentation/resident/contact/blocs/infor_contact/infor_contact_bloc.dart';

import 'package:social_network/presentation/resident/features/ecom/screens/cart/widget/cart_item_widget.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/router.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(GetCart());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CartBloc, CartState>(
      builder: (context, state) {
        if (state is CartLoadedState) {
          List<CartItem> cartItems = state.cart.items;
          int length = cartItems.length;
          if (length == 0) {
            return Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  title: const Text('Giỏ hàng'),
                ),
                body: const Center(
                  child: Text('Giỏ hàng trống'),
                ));
          }
          return Scaffold(
            appBar: AppBar(
              // ẩn nút back
              automaticallyImplyLeading: false,
              title: const Text('Giỏ hàng'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(item: cartItems[index]);
                    },
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.zero,
              child: BlocConsumer<InforContactBloc, InforContactState>(
                listener: (context, state) {
                  if (state is InforContactUpdated) {
                    navService.pushNamed(context, RouterClient.checkOut);
                  }
                },
                builder: (context, state) {
                  Function? onPressed;

                  if (state is InforContactLoaded) {
                    onPressed = () =>
                        navService.pushNamed(context, RouterClient.checkOut);
                  } else {
                    //if (state is InforContactEmpty)
                    onPressed = () =>
                        navService.pushNamed(context, RouterClient.contact);
                  }

                  return CustomButton(
                    height: 54.0,
                    title: 'Đặt hàng',
                    onPressed: () => onPressed!(),
                  );
                },
              ),
            ),
          );
        } else if (state is CartError) {
          return Center(
            child: ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(GetCart());
                },
                child: const Text('Lỗi vui lòng thử lại')),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
