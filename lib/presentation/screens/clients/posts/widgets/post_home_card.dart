import 'package:flutter/material.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/utils.dart';

class PostHomeCard extends StatelessWidget {
  final PostModel post;
  const PostHomeCard({super.key, required this.post});

  void onTapPost(BuildContext context) {
    if (post is EventModel) {
      logger.d('EventModel $post');
      // navService.pushNamed(context, RouterClient.postDetail, args: post);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final textTimeStyle = theme.textTheme.labelMedium!.copyWith(
      color: Colors.grey,
      fontSize: 14,
    );

    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.white,
      child: InkWell(
        onTap: () => onTapPost(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomImageView(
                url: post.image ?? '',
                width: double.infinity,
                // height: 200,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
              ),
            ),
            const Divider(thickness: 0.4),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${post.title}',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .copyWith(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  switch (post.type) {
                    PostType.event => Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: TextFormat.formatDate(
                                      (post as EventModel).beginDate),
                                  style: textTimeStyle,
                                ),
                                TextSpan(
                                  text: ' - ',
                                  style: textTimeStyle,
                                ),
                                TextSpan(
                                  text: TextFormat.formatDate(
                                      (post as EventModel).endDate),
                                  style: textTimeStyle,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    _ => Row(
                        children: [
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: Colors.grey,
                            size: 14,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            TextFormat.formatDate(post.createdAt),
                            style: textTimeStyle,
                          ),
                        ],
                      ),
                  },
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
