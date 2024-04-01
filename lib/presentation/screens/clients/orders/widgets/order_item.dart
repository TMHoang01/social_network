import 'package:flutter/material.dart';
import 'package:social_network/domain/models/ecom/cart_item.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/utils/text_format.dart';

class OderItemWidget extends StatelessWidget {
  final CartItem item;
  const OderItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const SizedBox(width: 8.0),
          Text(
            '${item.quantity} x ',
            style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
          ),
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
                      fontSize: 16.0,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              '₫ ${TextFormat.formatMoney(item.price * item.quantity)}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
