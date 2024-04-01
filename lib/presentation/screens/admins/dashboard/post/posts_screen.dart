import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/blocs/admins/posts/posts_bloc.dart';
import 'package:social_network/presentation/screens/admins/posts/widgets/post_card.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/utils.dart';

final blocPosts = sl.get<PostsBloc>()..add(PostsStarted());

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen>
    with AutomaticKeepAliveClientMixin<PostsScreen> {
  @override
  bool get wantKeepAlive => true;

  final List<PostCreateBloc> _postCreateBlocs = [];
  _handleNewPostBtn(BuildContext context) {
    final bloc = sl.get<PostCreateBloc>();
    // _postCreateBlocs.add(bloc);
    setState(() {
      _postCreateBlocs.insert(0, bloc);
    });
    // logger.i({'_postCreateBlocs add': _postCreateBlocs.length});
    bloc.stream.listen(
      (state) {
        // logger.i({'state': state});
        if (state is PostCreateSuccess) {
          // _postCreateBlocs.remove(bloc);
          setState(() {
            _postCreateBlocs.remove(bloc);
          });
          // logger.i({'_postCreateBlocs remove': _postCreateBlocs.length});
          bloc.close();
        }
      },
    );

    Navigator.pushNamed(context, RouterAdmin.postAdd, arguments: bloc);
  }

  _handlePostReTry(PostCreateBloc bloc) {
    final state = bloc.state as PostCreateFailure;

    bloc.add(PostCreateRetryStared(
      title: state.post.title ?? '',
      content: state.post.content ?? '',
      imagePath: state.post.image ?? '',
    ));
  }

  Widget _buildFailurePost(PostCreateBloc bloc) {
    final state = bloc.state as PostCreateFailure;
    final theme = Theme.of(context);

    final pendingPost = Stack(
      children: [
        PostCardWidget(
          post: state.post,
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white70,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    color: theme.colorScheme.error,
                  ),
                  Text(
                    state.error,
                    style: theme.textTheme.labelSmall!.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  IconButton.filled(
                    onPressed: () {
                      _handlePostReTry(bloc);
                    },
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
    return pendingPost;
  }

  Widget _buildPendingPost(PostCreateInProcess state) {
    final pendingPost = Stack(
      children: [
        PostCardWidget(
          post: state.post,
        ),
        Positioned.fill(
          child: Container(
            color: Colors.white70,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
    return pendingPost;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    Size size = MediaQuery.of(context).size;

    final pendingPosts = _postCreateBlocs.map(
      (bloc) {
        return BlocProvider.value(
          value: bloc,
          child: BlocConsumer<PostCreateBloc, PostCreateState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is PostCreateSuccess) {
                blocPosts.add(PostInsertStarted(post: state.post));
              }
            },
            builder: (context, state) {
              logger.i({'bloc build': bloc.state.runtimeType});
              if (state is PostCreateInProcess) {
                return _buildPendingPost(state);
              } else if (state is PostCreateFailure) {
                return _buildFailurePost(bloc);
              }
              return const SizedBox();
            },
          ),
        );
      },
    ).toList();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tin tức'),
        actions: [
          IconButton(
            onPressed: () {
              _handleNewPostBtn(context);
            },
            icon: const Icon(
              Icons.add,
              // color: Colors.white,
            ),
          ),
        ],
      ),
      body: BlocProvider.value(
        value: blocPosts,
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ChipCard(
                          label: 'Tất cả',
                          backgroundColor: kPrimaryColor,
                          onTap: () {},
                        ),
                        const ChipCard(
                          label: 'Chờ xác nhận',
                        ),
                        const ChipCard(
                          label: 'Đã xác nhận',
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),
                ...pendingPosts,
                PostCardWidget(
                  post: PostModel(
                    title: 'title',
                    content: 'content',
                    image: 'https://picsum.photos/200/300',
                  ),
                ),
                _buildListPost(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListPost() {
    return BlocBuilder<PostsBloc, PostsState>(
      bloc: blocPosts,
      builder: (context, state) {
        return (switch (state) {
          PostsLoadInProgress() => const Center(
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
          _ => const SizedBox(),
        });
      },
    );
  }
}
