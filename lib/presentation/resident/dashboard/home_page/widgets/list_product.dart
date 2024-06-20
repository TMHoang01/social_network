import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/cart/cart_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/screens/cart/widget/change_num_btn.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/app_styles.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/utils/text_format.dart';

class ListProductsWidget extends StatefulWidget {
  List<ProductModel> products;
  ListProductsWidget({super.key, required this.products});

  @override
  State<ListProductsWidget> createState() => _ListProductsWidgetState();
}

class _ListProductsWidgetState extends State<ListProductsWidget> {
  @override
  Widget build(BuildContext context) {
    int length = widget.products.length;
    return Container(
      color: kOfWhite,
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 10.0,
          childAspectRatio: 0.7,
        ),
        // padding: const EdgeInsets.all(16),
        itemBuilder: (BuildContext context, int index) {
          return ProductItem(
            product: widget.products[index],
          );
        },
      ),
    );
  }
}

class ProductItem extends StatelessWidget {
  ProductModel product;
  ProductItem({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    // read sate in bloccart
    final cartBloc = context.watch<CartBloc>();
    List<CartItem> items = [];
    if (cartBloc.state is CartLoadedState) {
      items = (cartBloc.state as CartLoadedState).cart.items;
    }
    bool isExist = items.any((element) => element.productId == product.id);
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      // color: kTertiary,
      child: InkWell(
        // onTap: () => Navigator.pushNamed(
        //   context,
        //   RouterClient.productDetail,
        //   arguments: product,
        // ),
        onTap: () => navService.pushNamed(context, RouterClient.productDetail,
            args: product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomImageView(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              url: product.imageUrl,
              width: size.width * 0.4,
              height: size.width * 0.36,
              boxFit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Flexible(
                      flex: 5,
                      child: Text(
                        "${product.name}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: appStyle(18, Colors.black, FontWeight.w400),
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8, left: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      "${TextFormat.formatMoney(product.price ?? 0)} đ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: appStyle(16, Colors.blue, FontWeight.w400),
                    ),
                  ),
                  isExist == false
                      ? IconButton.filled(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(kPrimaryColor),
                          ),
                          onPressed: () {
                            context.read<CartBloc>().add(
                                  AddItemCart(item: product),
                                );
                            // _showBottomSheetAddCart(context, product);
                          },
                          icon: const Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                          ),
                        )
                      : ButtonAddCart(
                          item: items.firstWhere(
                              (element) => element.productId == product.id),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showBottomSheetAddCart(
      BuildContext context, ProductModel product) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(34.0), topRight: Radius.circular(34.0)),
      ),
      builder: (context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Column(
            children: [
              Text("Add to cart"),
              Text("Quantity"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                  ),
                  Text("1"),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<CartBloc>().add(
                        AddItemCart(item: product),
                      );
                  navService.pop(context);
                },
                child: const Text("Add to cart"),
              ),
            ],
          ),
        );
      },
    );
  }
}
