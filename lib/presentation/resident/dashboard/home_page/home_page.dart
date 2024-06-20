import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/products/product_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/blocs/cart/cart_bloc.dart';
import 'package:social_network/presentation/resident/features/ecom/screens/cart/widget/change_num_btn.dart';
import 'package:social_network/presentation/resident/features/post/blocs/posts/posts_bloc.dart';
import 'package:social_network/presentation/resident/features/post/screens/widgets/post_home_card.dart';
import 'package:social_network/presentation/resident/router_client.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/router.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/utils.dart';

class ItemHomePage {
  final String title;
  final IconData icon;
  final Color? color;
  final Function onTap;
  ItemHomePage({
    required this.title,
    required this.icon,
    this.color,
    required this.onTap,
  });
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
// with AutomaticKeepAliveClientMixin<HomePage>
{
  // @override
  // bool get wantKeepAlive => true;
  final List<ItemHomePage> listFunction = [
    ItemHomePage(
      title: 'Khiếu nại',
      icon: Icons.feedback,
      color: Colors.blue,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterClient.feedback);
      },
    ),
    ItemHomePage(
      title: 'Tin tức',
      icon: Icons.list,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterClient.posts);
      },
    ),
    ItemHomePage(
      title: 'Dịch vụ',
      color: Colors.red,
      icon: FontAwesomeIcons.personWalkingLuggage,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterClient.services);
      },
    ),
    ItemHomePage(
      title: 'Lịch hẹn',
      color: Colors.orange,
      icon: FontAwesomeIcons.userClock,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterClient.mySchedule);
      },
    ),
    ItemHomePage(
      title: 'Xe cư dân',
      icon: FontAwesomeIcons.car,
      color: Colors.blue,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterClient.parkingVehicle);
      },
    ),
    ItemHomePage(
      title: 'Bãi đỗ xe',
      icon: FontAwesomeIcons.squareParking,
      color: Colors.green,
      onTap: (BuildContext context) {
        navService.pushNamed(context, RouterClient.parking);
      },
    ),
  ];

  late ProductBloc productBloc;
  late PostsClientBloc postBloc1 = sl.get<PostsClientBloc>()
    ..add(PostsStarted(type: PostType.news.toJson()));
  late PostsClientBloc postBloc2 = sl.get<PostsClientBloc>()
    ..add(PostsStarted(type: PostType.event.toJson()));
  @override
  void initState() {
    super.initState();
    productBloc = BlocProvider.of<ProductBloc>(context)
      ..add(FetchProductsEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    // super.build(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: const Text('Trang chủ'),
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
                    icon: const Icon(Icons.notifications),
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
            // Container(
            //   color: kPrimaryColor,
            //   padding: const EdgeInsets.all(12),
            //   // height: 300,
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         'Hỗ trợ dịch vụ, tiện ích cho bạn',
            //         style: theme.textTheme.headlineMedium
            //             ?.copyWith(color: Colors.white),
            //       ),
            //       const SizedBox(height: 10),
            //       Row(
            //         children: [
            //           Container(
            //             width: 18,
            //             height: 18,
            //             decoration: BoxDecoration(
            //               borderRadius: BorderRadius.circular(90),
            //               color: kSecondaryLightColor,
            //             ),
            //             child: const Icon(Icons.star,
            //                 color: Colors.amber, size: 15),
            //           ),
            //           const SizedBox(width: 2),
            //           const Text(
            //             'Đánh giá:',
            //             style: TextStyle(
            //                 fontSize: 16, color: kSecondaryLightColor),
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

            // SizedBox(
            //   height: size.height * 0.24,
            //   child: Swiper(
            //     itemCount: 3,
            //     itemBuilder: (BuildContext context, int index) {
            //       return CustomImageView(
            //         imagePath: ImageConstant.banners[index],
            //         width: size.width,
            //         height: size.height * 0.24,
            //       );
            //     },
            //     pagination: const SwiperPagination(
            //       alignment: Alignment.bottomCenter,
            //       builder: DotSwiperPaginationBuilder(
            //         color: Colors.grey,
            //         activeColor: kSecondaryColor,
            //       ),
            //     ),
            //   ),
            // ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(height: 3),
            ),
            // _buildFuntionItem(context, listFunction.sublist(0, 4)),
            _buildGridView(listFunction),
            Container(
              padding: const EdgeInsets.all(8),
              height: 10,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        CircleAvatar(),
                        InkWell(
                          onTap: () {
                            if (index == 4) {
                              navService.pushNamed(
                                  context, RouterClient.products);
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
                                color: Colors.green,
                                size: 30,
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tin tức", style: theme.textTheme.headlineSmall),
                  InkWell(
                    onTap: () {
                      navService.pushNamed(context, RouterClient.posts);
                    },
                    child: Text(
                      "Xem thêm",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: kSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildPostsHome(context, postBloc1),

            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sự kiện", style: theme.textTheme.headlineSmall),
                  InkWell(
                    onTap: () {
                      navService.pushNamed(context, RouterClient.posts);
                    },
                    child: Text(
                      "Xem thêm",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: kSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildPostsHome(context, postBloc2),

            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 12.0, right: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Mua sắm", style: theme.textTheme.headlineSmall),
                  InkWell(
                    onTap: () {
                      navService.pushNamed(context, RouterClient.products);
                    },
                    child: Text(
                      "Xem thêm",
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: kSecondaryColor,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
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
                    height: size.width * 0.4,
                    child: ListView.separated(
                      itemCount: products.length,
                      scrollDirection: Axis.horizontal,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
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
          ],
        ),
      ),
    );
  }

  Widget _buildPostsHome(BuildContext context, PostsClientBloc bloc) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<PostsClientBloc, PostsClientState>(
      bloc: bloc,
      builder: (context, state) {
        return (state is PostsClientsLoadInProgress)
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : (state is PostsLoadSuccess)
                ? SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      // shrinkWrap: true,
                      itemCount: state.posts.length,
                      itemBuilder: (context, index) {
                        return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: size.width * 0.86,
                            child: PostHomeCard(post: state.posts[index]));
                      },
                    ),
                  )
                : const Text("State not found");
      },
    );
  }

  GridView _buildGridView(List<ItemHomePage> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: list.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 2,
        mainAxisSpacing: 0,
        childAspectRatio: 1.34,
      ),
      itemBuilder: (context, index) {
        final item = list[index];
        return ItemHomeBox(item: item);
      },
    );
  }
}

class ItemHomeBox extends StatelessWidget {
  final ItemHomePage item;
  const ItemHomeBox({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return InkWell(
      onTap: () {
        item.onTap(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        width: 60,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                shape: BoxShape.rectangle,
              ),
              child: Icon(
                item.icon,
                size: 24,
                color: item.color,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: BorderSide.strokeAlignCenter,
              ),
            ),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }
}

SizedBox _buildFuntionItem(
  BuildContext context,
  List<ItemHomePage> listItems,
) {
  Size size = MediaQuery.of(context).size;
  ThemeData theme = Theme.of(context);
  return SizedBox(
    width: size.width,
    height: 128,
    child: Row(
      children: listItems.map((item) {
        return Expanded(
          child: Container(
            width: size.width * 0.2,
            margin: const EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                  width: size.width * 0.2,
                  height: size.width * 0.2,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kOfWhite,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: kOfWhite,
                      width: 1,
                    ),
                    gradient: const LinearGradient(
                      colors: [kPrimaryLightColor, kSecondaryLightColor],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      item.onTap(context);
                    },
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(200),
                      child: FittedBox(
                        child: Icon(
                          item.icon,
                          color: item.color,
                        ),
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Text(item.title, style: theme.textTheme.bodyMedium),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
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
      width: size.width * 0.8,
      color: Colors.white,
      child: Card(
        surfaceTintColor: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  CustomImageView(
                    borderRadius: BorderRadius.circular(10),
                    url: product.imageUrl,
                    width: size.width * 0.3,
                    height: size.width * 0.6,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text("${product.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium),
                  FittedBox(
                    child: Text(
                      "${TextFormat.formatMoney(product.price ?? 0)} đ",
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: kSecondaryColor),
                    ),
                  ),
                  Expanded(child: Container()),
                  Row(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                  ),
                  const Text("1"),
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
