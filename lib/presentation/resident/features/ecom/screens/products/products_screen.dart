import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/presentation/provider/ecom/blocs/products/product_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/cart/cart_bloc.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    context.read<ManageProductBloc>().add(GetManageProductsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBuilder(context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // sreach bar
            // Container(
            //   padding: const EdgeInsets.all(12),
            //   child: CustomTextFormField(
            //     hintText: "Tìm kiếm",
            //     suffix: const Icon(Icons.search),
            //   ),
            // ),

            BlocBuilder<ManageProductBloc, ManageProductState>(
              builder: (context, state) {
                if (state is ManageProductLoading ||
                    state is ManageProductInitial) {
                  return const CircularProgressIndicator();
                }
                if (state is ManageProductError) {
                  return const Text("Load product failure");
                }
                if (state is ManageProductSuccess) {
                  List<ProductModel> products =
                      context.read<ManageProductBloc>().listProducts;
                  logger.i(products.length);
                  int length = products.length;
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: length,
                        itemBuilder: (ctt, index) {
                          ProductModel product = products[index];
                          return InkWell(
                            onTap: () {
                              // logger.d(product);
                              navService.pushNamed(
                                  context, RouterClient.productDetail,
                                  args: product);
                            },
                            child: ListTile(
                              leading: CustomImageView(
                                url: product.imageUrl,
                                width: 54,
                                height: 54,
                                boxFit: BoxFit.cover,
                              ),
                              title: Text(
                                '${product.name}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Text(
                                '${TextFormat.formatMoney(product.price ?? 0)}đ',
                                style: const TextStyle(
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
                return Text('Không có dữ liệu');
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar appBuilder(BuildContext context) {
    return AppBar(
      title: const Text("Danh sách sản phẩm"),
      actions: [
        BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            return Row(
              children: [
                // Text(' ');
                IconButton(
                  onPressed: () {
                    navService.pushNamed(context, RouterClient.cart);
                  },
                  icon: const Icon(FontAwesomeIcons.cartArrowDown),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
