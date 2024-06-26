import 'package:flutter/material.dart';
import 'package:social_network/domain/models/post/news.dart';
import 'package:social_network/utils/utils.dart';

class ContentNewsDetails extends StatelessWidget {
  const ContentNewsDetails({
    super.key,
    required this.post,
  });

  final NewsModel post;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${post.title}',
                style: theme.textTheme.headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 4),
              if (post.createdAt != null)
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: kGrayLight,
                      size: 16,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      TextFormat.formatDate(post.createdAt),
                      style: theme.textTheme.labelLarge!.copyWith(
                        color: kGrayLight,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('${post.content}',
              style: theme.textTheme.labelLarge!.copyWith(fontSize: 18)),
        ),
      ],
    );
  }
}
