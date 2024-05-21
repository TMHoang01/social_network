import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:social_network/utils/utils.dart';

class RatingStarIcon extends StatelessWidget {
  final double? rating;
  final Function(double)? onRatingUpdate;
  final double? size;
  final EdgeInsetsGeometry? padding;
  final bool allowHalfRating;
  final bool isEdit;
  const RatingStarIcon({
    super.key,
    this.rating,
    this.onRatingUpdate,
    this.size,
    this.padding,
    this.isEdit = false,
    this.allowHalfRating = false,
  });

  @override
  Widget build(BuildContext context) {
    return RatingBar(
        ignoreGestures: !isEdit,
        initialRating: rating ?? 0,
        direction: Axis.horizontal,
        itemCount: 5,
        itemSize: size ?? 20,
        itemPadding: padding ?? EdgeInsets.zero,
        // itemBuilder: (context, _) => const Icon(
        //       Icons.star,
        //       color: kSecondaryColor,
        //     ),
        ratingWidget: RatingWidget(
          full: const Icon(Icons.star, color: Colors.amber),
          half: const Icon(Icons.star_half, color: Colors.amber),
          empty: const Icon(Icons.star_border, color: Colors.amber),
        ),
        allowHalfRating: allowHalfRating,
        onRatingUpdate: onRatingUpdate ?? (vaule) {});
  }
}
