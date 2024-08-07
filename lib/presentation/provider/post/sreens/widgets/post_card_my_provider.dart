import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/provider/screens/router_admin.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class PostCardMyProviderWidget extends StatelessWidget {
  final PostModel post;
  final File? file;
  const PostCardMyProviderWidget({super.key, required this.post, this.file});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      height: 144,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kGrayLight.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _onNavigateToPostDetail(context),
        child: Row(
          children: [
            CustomImageView(
              boxFit: BoxFit.fitWidth,
              imagePath: file?.path,
              url: post.image ?? '',
              width: size.width * 0.3,
              // borderRadius: const BorderRadius.only(
              //   topLeft: Radius.circular(12),
              //   bottomLeft: Radius.circular(12),
              // ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${post.title}',
                            maxLines: 1,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${post.content}',
                            style: theme.textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _buildStatus(post.status),
                        post.createdAt == null
                            ? const SizedBox()
                            : ChipCard(
                                label: TextFormat.formatDate(post.createdAt))
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatus(String? status) {
    if (status == null) return const ChipCard(label: 'Chờ duyệt');
    return ChipCard(label: status);
  }

  _onNavigateToPostDetail(BuildContext context) {
    navService.pushNamed(context, RouterAdmin.postDetail, args: post);
  }
}
