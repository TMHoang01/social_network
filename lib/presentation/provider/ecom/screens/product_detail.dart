import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/product_model.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/utils/app_styles.dart';
import 'package:social_network/utils/constants.dart';
import 'package:social_network/utils/text_format.dart';

class AdminProductDetail extends StatelessWidget {
  const AdminProductDetail({super.key, this.product});

  final ProductModel? product;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          titleTextStyle: appStyle(20, Colors.black, FontWeight.bold),
          title: const Text("Chi tiết sản phẩm"),
          actions: [
            IconButton(
              onPressed: () {
                // context.go(AppRouter.settings);
              },
              icon: const Icon(Icons.add_location_alt),
            ),
          ],
        ),
        body: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomImageView(
                  url: product?.imageUrl,
                  width: double.infinity,
                  height: size.height * 0.36,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                product?.name ?? '',
                                style:
                                    appStyle(18, Colors.black, FontWeight.w500),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kPrimaryColor,
                              ),
                              child: Text(
                                "${TextFormat.formatMoney(product?.price ?? 0)}đ",
                                style:
                                    appStyle(18, Colors.black, FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Mô tả sản phẩm",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product?.description ?? '',
                        style: appStyle(15, Colors.grey, FontWeight.w400),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Row(
            children: [
              // Expanded(
              //   child: CustomButton(
              //     onPressed: () {

              //     },
              //     title: 'Thêm vào giỏ hàng',
              //   ),
              // ),
              // Expanded(
              //   child: CustomButton(
              //     onPressed: () {},
              //     title: 'Mua ngay',
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
