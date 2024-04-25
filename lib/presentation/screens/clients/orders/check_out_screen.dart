import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';
import 'package:social_network/presentation/blocs/clients/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/blocs/clients/order/order_bloc.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

import 'widgets/widgets.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    TextEditingController _noteController = TextEditingController();

    return BlocListener<OrderBloc, OrderState>(
      listener: (context, state) {
        if (state is OrderSuccessAdd) {
          BlocProvider.of<CartBloc>(context).add(ClearCart());
          navService.pushNamed(context, RouterClient.complete);
        } else if (state is OrderLoadError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đặt hàng'),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            color: kOfWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _builderInforCard(size),
                BlocBuilder<CartBloc, CartState>(
                  builder: (context, state) {
                    if (state is CartLoadedState) {
                      return Container(
                        decoration: _boxdecoration(),
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.cart.items.length,
                          itemBuilder: (context, index) {
                            return OderItemWidget(
                                item: state.cart.items[index]);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider();
                          },
                        ),
                      );
                    }
                    return const SizedBox();
                  },
                ),
                const SizedBox(height: 8.0),
                Container(
                  decoration: _boxdecoration(),
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      bottom: 16.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Ghi chú',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        CustomTextFormField(
                          // hintText: 'Nhập ghi chú',
                          controller: _noteController,
                          maxLines: 3,
                          textInputType: TextInputType.multiline,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: EdgeInsets.zero,
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state is CartLoadedState) {
                return CustomButton(
                    height: 54.0,
                    title:
                        'Đặt hàng ${TextFormat.formatMoneyWithSymbol(state.cart.totalAmount)} ',
                    onPressed: () {
                      final address = (context.read<InforContactBloc>().state
                              as InforContactLoaded)
                          .inforContact;
                      context.read<OrderBloc>().add(
                            CreateOrder(
                              items: state.cart.items,
                              total: state.cart.totalAmount,
                              note: _noteController.text.trim(),
                              address: address,
                            ),
                          );
                      navService.pushNamed(context, RouterClient.complete);
                    });
              }
              return CustomButton(
                height: 54.0,
                title: 'Đặt hàng',
                onPressed: () => logger.i('onPressed'),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _builderInforCard(Size size) {
    return BlocBuilder<InforContactBloc, InforContactState>(
      builder: (context, state) {
        if (state is InforContactLoaded) {
          return InforContactCard(infor: state.inforContact);
        } else if (state is InforContactLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is InforContactEmpty) {
          return const Center(child: Text('Chưa có thông tin liên hệ'));
        }
        return const SizedBox();
      },
    );
  }

  BoxDecoration _boxdecoration() {
    return BoxDecoration(
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: kGrayLight.withOpacity(0.3),
          blurRadius: 8,
          offset: const Offset(0.0, 8),
        )
      ],
    );
  }
}
