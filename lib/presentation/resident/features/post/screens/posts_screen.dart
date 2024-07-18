import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/resident/features/post/blocs/posts/posts_bloc.dart';
import 'package:social_network/utils/utils.dart';

import 'widgets/post_card.dart';

// final  context.read<PostsBloc>() = sl.get<PostsBloc>()..add(PostsStarted());

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  PostType? typePostSelected;
  @override
  void initState() {
    super.initState();
    initLoadData();
  }

  initLoadData() {
    context.read<PostsClientBloc>().add(const PostsStarted());
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức sự kiện'),
      ),
      body: Container(
        width: size.width,
        height: size.height,
        color: kOfWhite,
        child: RefreshIndicator(
          onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
            initLoadData();
          }),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // sreach bar
                // CustomTextFormField(
                //   margin: const EdgeInsets.all(10),
                //   hintText: 'Tìm kiếm',
                //   suffix: const Icon(Icons.search),
                // ),

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
                  initLoadData();
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
