import 'package:flutter/material.dart';
import 'package:social_network/domain/models/service/review_service.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/utils.dart';

class ReviewContentItem extends StatelessWidget {
  final ReviewService review;
  final Function()? onTapIcon;
  const ReviewContentItem({super.key, required this.review, this.onTapIcon});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.all(0),
          leading: CustomImageView(
            height: 44,
            width: 44,
            borderRadius: BorderRadius.circular(90),
            url: review.userAvatar,
          ),
          title: Text(
            review.userName ?? 'Cư dân ẩn danh',
          ),
          trailing:
              InkWell(onTap: onTapIcon, child: const Icon(Icons.more_vert)),
        ),
        Row(
          children: [
            RatingStarIcon(
              rating: review.rating ?? 0,
            ),
            const SizedBox(width: 12),
            Text(TextFormat.formatDate(review.createdAt)),
          ],
        ),
        const SizedBox(height: 10),
        Text(review.comment ?? ''),
      ],
    );
  }
}
