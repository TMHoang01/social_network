import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/blocs/clients/posts/posts_bloc.dart';
import './widgets/post_card.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/utils.dart';

// final  context.read<PostsBloc>() = sl.get<PostsBloc>()..add(PostsStarted());

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  PostType? typePostSelected;
  @override
  Widget build(BuildContext context) {
    // super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bài đăng'),
      ),
      body: BlocProvider.value(
        value: context.read<PostsClientBloc>(),
        child: Container(
          width: size.width,
          height: size.height,
          color: kOfWhite,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // sreach bar
                CustomTextFormField(
                  margin: const EdgeInsets.all(10),
                  hintText: 'Tìm kiếm',
                  suffix: const Icon(Icons.search),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BlocBuilder<PostsClientBloc, PostsClientState>(
                      builder: (context, state) {
                        final canLoadMore = switch (state) {
                          PostsLoadmoreEndSuccess() => false,
                          _ => true,
                        };
                        return StatefulBuilder(
                          builder: (ctx, setState) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ChipCard(
                                  label: 'Tất cả',
                                  backgroundColor: typePostSelected == null
                                      ? kPrimaryColor
                                      : null,
                                  onTap: () {
                                    context
                                        .read<PostsClientBloc>()
                                        .add(PostsStarted());
                                    setState(() {
                                      typePostSelected = null;
                                    });
                                  },
                                ),
                                ChipCard(
                                  label: 'Sự kiện',
                                  backgroundColor:
                                      typePostSelected == PostType.event
                                          ? kPrimaryColor
                                          : null,
                                  onTap: () {
                                    if (canLoadMore) {
                                      context
                                          .read<PostsClientBloc>()
                                          .add(PostsLoadmoreEvent(type: ''));
                                    }
                                    setState(() {
                                      typePostSelected = PostType.event;
                                    });
                                  },
                                ),
                                ChipCard(
                                  label: 'Tin tức',
                                  backgroundColor:
                                      typePostSelected == PostType.news
                                          ? kPrimaryColor
                                          : null,
                                  onTap: () {
                                    setState(() {
                                      typePostSelected = PostType.news;
                                    });
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                _buildListPost(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return BlocBuilder<PostsClientBloc, PostsClientState>(
      bloc: context.read<PostsClientBloc>(),
      builder: (context, state) {
        return (switch (state) {
          PostsClientsLoadInProgress() => const Center(
              child: CircularProgressIndicator(),
            ),
          PostsLoadSuccess(posts: final posts) => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: posts.length,
              separatorBuilder: (context, index) => const SizedBox(height: 2),
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCardWidget(post: post);
              },
            ),
          PostsLoadFailure(error: final error) => Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<PostsClientBloc>().add(PostsStarted());
                },
                child: Text(error),
              ),
            ),
          _ => const SizedBox(),
        });
      },
    );
  }
}
