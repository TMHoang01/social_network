import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';
import 'package:social_network/presentation/blocs/clients/order/order_bloc.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/utils/constants.dart';

class CompleteScreen extends StatelessWidget {
  const CompleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocListener<OrderBloc, OrderState>(
          listener: (context, state) {
            if (state is OrderSuccessAdd) {
              BlocProvider.of<CartBloc>(context).add(ClearCart());
            }
          },
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomImageView(
                    svgPath: ImageConstant.iconCheckMark,
                    height: 97,
                    width: 87),
                const SizedBox(height: 39),
                Container(
                  width: 279,
                  margin: const EdgeInsets.only(left: 33, right: 31),
                  child: const Text(
                    "Đã đặt hàng thành công \nCảm ơn bạn đã mua hàng của chúng tôi",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                      color: kPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: 53),
                CustomButton(
                  title: "Quay trở lại trang chủ",
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                        context, RouterCLient.dashboard, (route) => false);
                  },
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
