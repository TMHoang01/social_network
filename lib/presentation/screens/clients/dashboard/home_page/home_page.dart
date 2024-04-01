import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/presentation/blocs/clients/products/product_bloc.dart';
import 'package:social_network/presentation/blocs/clients/cart/cart_bloc.dart';
import 'package:social_network/presentation/screens/clients/cart/widget/change_num_btn.dart';
import 'package:social_network/presentation/screens/clients/router_client.dart';
import 'package:social_network/presentation/screens/admins/products/products_screen.dart';
import 'package:social_network/presentation/screens/clients/dashboard/home_page/widgets/list_product.dart';
import 'package:social_network/utils/app_styles.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/utils/logger.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/utils/utils.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin<HomePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    super.build(context);
    ProductBloc productBloc = BlocProvider.of<ProductBloc>(context)
      ..add(FetchProductsEvent());
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Trang chủ'),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              return Row(
                children: [
                  // Text(' ');
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, RouterCLient.cart);
                    },
                    icon: const Icon(Icons.shopping_cart),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.24,
              child: Swiper(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return CustomImageView(
                    imagePath: ImageConstant.banners[index],
                    width: size.width,
                    height: size.height * 0.24,
                  );
                },
                pagination: const SwiperPagination(
                  alignment: Alignment.bottomCenter,
                  builder: DotSwiperPaginationBuilder(
                    color: Colors.grey,
                    activeColor: kSecondaryColor,
                  ),
                ),
                // control: SwiperControl(),
              ),
            ),
            const Divider(height: 3),
            // Container(
            //   color: kPrimaryLightColor,
            //   padding: const EdgeInsets.all(12),
            //   // height: 300,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       const Text(
            //         'Của hàng bán ',
            //         style: TextStyle(
            //           fontSize: 30,
            //           fontWeight: FontWeight.w400,
            //         ),
            //       ),
            //       const SizedBox(height: 10),
            //       Row(
            //         children: [
            //           Container(
            //             width: 18,
            //             height: 18,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(90),
            //               color: Colors.purple,
            //             ),
            //             child: const Icon(Icons.star,
            //                 color: Colors.amber, size: 15),
            //           ),
            //           const SizedBox(width: 2),
            //           const Text(
            //             'Đánh giá:',
            //             style: TextStyle(fontSize: 16, color: Colors.purple),
            //           ),
            //           const SizedBox(width: 4),
            //           const Text(
            //             '100 người',
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: Colors.black,
            //             ),
            //           ),
            //           const SizedBox(width: 6),
            //           RatingBar.builder(
            //             itemSize: 16,
            //             initialRating: 3,
            //             minRating: 0,
            //             direction: Axis.horizontal,
            //             allowHalfRating: true,
            //             itemCount: 5,
            //             itemPadding:
            //                 const EdgeInsets.symmetric(horizontal: 2.0),
            //             itemBuilder: (context, _) => const Icon(
            //               Icons.star,
            //               color: Colors.amber,
            //             ),
            //             onRatingUpdate: (rating) {
            //               print(rating);
            //             },
            //           ),
            //         ],
            //       ),
            //     ],
            //   ),
            // ),

            Container(
              padding: const EdgeInsets.all(8),
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            if (index == 4) {
                              Navigator.pushNamed(
                                context,
                                RouterCLient.products,
                              );
                            }
                          },
                          child: Container(
                            width: 64,
                            height: 64,
                            // color: Colors.grey[200],
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(90),
                              color: kOfWhite,
                              border: Border.all(
                                color: kOfWhite,
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.online_prediction_rounded,
                                color: Colors.white, // Màu của biểu tượng
                                size: 50, // Kích thước của biểu tượng
                              ),
                            ),
                          ),
                        ),
                        const Text("Thể loại"),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(height: 1),
            // const LineChartSample1(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  Text("Gợi ý cho bạn", style: theme.textTheme.headlineSmall),
            ),
            const SizedBox(height: 10),
            BlocBuilder<ProductBloc, ProductState>(
              bloc: productBloc,
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const CircularProgressIndicator();
                }
                if (state is ProductSuccess) {
                  final products = state.products;
                  return SizedBox(
                    height: size.width * 0.3,
                    child: ListView.separated(
                      itemCount: products.length,
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (conxtext, index) {
                        return PreviewProductWidget(product: products[index]);
                      },
                    ),
                  );
                }
                if (state is ProductError) {
                  return const Text("Load product failure");
                }
                return const Text("State not found");
              },
            ),

            const SizedBox(height: 10),
            // BlocBuilder<ProductBloc, ProductState>(
            //   bloc: productBloc,
            //   builder: (context, state) {
            //     if (state is ProductLoading) {
            //       return const CircularProgressIndicator();
            //     }
            //     if (state is ProductError) {
            //       return const Text("Load product failure");
            //     }
            //     if (state is ProductSuccess) {
            //       return ListProductsWidget(products: state.products);
            //     }
            //     return const Text("State not found");
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}

class PreviewProductWidget extends StatelessWidget {
  final ProductModel product;
  const PreviewProductWidget({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final cartBloc = context.watch<CartBloc>();
    List<CartItem> items = [];
    if (cartBloc.state is CartLoadedState) {
      items = (cartBloc.state as CartLoadedState).cart.items;
    }
    bool isExist = items.any((element) => element.productId == product.id);
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(8),
      width: size.width * 0.6,
      decoration: BoxDecoration(
        color: kOfWhite,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomImageView(
            borderRadius: BorderRadius.circular(10),
            url: product.imageUrl,
            width: size.width * 0.24,
            height: size.width * 0.20,
          ),
          const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${product.name}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge),
                FittedBox(
                  child: Text(
                    "${TextFormat.formatMoney(product.price ?? 0)} đ",
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: kSecondaryColor),
                  ),
                ),
                FittedBox(
                  child: Row(
                    children: [
                      // IconButton(
                      //   onPressed: () {},
                      //   icon: const Icon(Icons.favorite),
                      // ),
                      isExist == false
                          ? IconButton.filled(
                              iconSize: 18,
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
        ],
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
                  Navigator.pop(context);
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
