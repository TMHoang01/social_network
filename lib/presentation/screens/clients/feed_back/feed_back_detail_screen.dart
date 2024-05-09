import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:social_network/domain/models/feed_back/feed_back.dart';
import 'package:social_network/presentation/blocs/clients/my_feed_back/my_feed_back_bloc.dart';
import 'package:social_network/presentation/widgets/custom_image_view.dart';
import 'package:social_network/presentation/widgets/custom_input.dart';
import 'package:social_network/utils/utils.dart';

import './widgets/widgets.dart';

class FeedBackDetailsScreen extends StatefulWidget {
  final FeedBackModel item;
  const FeedBackDetailsScreen({super.key, required this.item});

  @override
  State<FeedBackDetailsScreen> createState() => _FeedBackDetailsScreenState();
}

class _FeedBackDetailsScreenState extends State<FeedBackDetailsScreen> {
  late FeedBackModel item;

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Phản ánh'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: size.width,
              height: 86,
              child: TimelineProcessFeedBack(
                  status: item.status ?? FeedBackStatus.pending),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nội dung phản ánh',
                    style: theme.textTheme.titleMedium,
                  ),
                  _builTitle('Nguời tạo:', widget.item.userName ?? ''),
                  _builTitle(
                      'Ngày tạo:',
                      TextFormat.formatDate(widget.item.createdAt,
                          formatType: 'HH:MM dd/MM/yyyy')),
                  _builTitle('Trạng thái', widget.item.status?.toName() ?? ''),
                  const SizedBox(height: 2),
                  const Text('Nội dung: '),
                  Text('${widget.item.content}'),
                  if (widget.item.image != null)
                    CustomImageView(
                      url: widget.item.image,
                      width: size.width,
                      height: 200,
                    ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(height: 50),
            BlocBuilder<MyFeedBackBloc, MyFeedBackState>(
              builder: (context, state) {
                if (state is MyFeedBackLoaded) {
                  item = state.feedBacks
                      .firstWhere((element) => element.id == widget.item.id);
                  if (item.status == FeedBackStatus.completed) {
                    return FormReviewFeedBack(feedBackId: widget.item.id ?? '');
                  }
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Đánh giá mức độ hài lòng',
                            style: theme.textTheme.titleMedium,
                          ),
                          const Text(
                              'Vui lòng đánh để nâng cao chất lượng dịch vụ của chúng tôi'),
                        ],
                      ),
                    ),
                    RatingBar.builder(
                      ignoreGestures: true,
                      initialRating: item.rating ?? 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: kSecondaryColor,
                        size: 16,
                      ),
                      onRatingUpdate: (vaule) {},
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      initialValue: item.review,
                      readOnly: true,
                      hintText: 'Đánh giá',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            const SizedBox(height: 26),
          ],
        ),
      ),
    );
  }

  Widget _builTitle(String title, String value) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(width: 4),
        Text(value),
      ],
    );
  }
}
