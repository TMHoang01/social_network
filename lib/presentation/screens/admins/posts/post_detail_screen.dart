import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/news.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/blocs/admins/post_detail/post_detail_bloc.dart';
import 'package:social_network/presentation/blocs/admins/posts/posts_bloc.dart';
import 'package:social_network/presentation/screens/admins/posts/widgets/content_event_detail.dart';
import 'package:social_network/presentation/screens/admins/posts/widgets/content_news_detail.dart';
import 'package:social_network/presentation/screens/admins/router_admin.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/utils.dart';

class PostDetailScreen extends StatefulWidget {
  final PostModel post;
  const PostDetailScreen({super.key, required this.post});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isPinned = false;
  final double _expandedHeight = 200;
  final bloc = sl.get<PostDetailBloc>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      logger.d('offset: ${_scrollController.offset}');
      if (!_isPinned &&
          _scrollController.hasClients &&
          _scrollController.offset > _expandedHeight) {
        setState(() {
          _isPinned = true;
        });
      } else if (_isPinned &&
          _scrollController.hasClients &&
          _scrollController.offset < _expandedHeight) {
        setState(() {
          _isPinned = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {});
    _scrollController.dispose();
    super.dispose();
  }

  void _handleBottomSheet(BuildContext context) {
    showBottomSheetApp(
      context: context,
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.edit),
            title: Text('Chỉnh sửa ${widget.post.type}'),
            onTap: () {
              navService.pop(context);
              _navigateToPostCreateScreen(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.delete),
            title: const Text('Xóa'),
            onTap: () {
              navService.pop(context);
              _handleDeletePost(context);
            },
          ),
          // if (widget.post.type == PostType.event)
          Column(
            children: [
              const Divider(),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('Mời bạn bè'),
                onTap: () {
                  navService.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.share),
                title: const Text('Chia sẻ'),
                onTap: () {
                  navService.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _navigateToPostCreateScreen(BuildContext context) {
    final bloc = sl.get<PostCreateBloc>()..add(PostEditInitEvent(widget.post));
    bloc.stream.listen(
      (state) {
        if (state is PostCreateSuccess) {
          context.read<PostsBloc>().add(PostUpdateStarted(post: state.post));
          bloc.close();
        }
      },
    );

    navService.pushNamed(context, RouterAdmin.postAdd, args: bloc);
  }

  void _handleDeletePost(BuildContext context) {
    // confirm dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận'),
          content: const Text('Bạn có chắc chắn muốn xóa bài viết này không?'),
          actions: [
            TextButton(
              onPressed: () {
                navService.pop(context);
              },
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                bloc.add(PostDetailDeleteStarted(post: widget.post));
                navService.pop(context);
              },
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _deletePostInlist(BuildContext context) {
    context.read<PostsBloc>().add(PostDeleteStarted(post: widget.post));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    PostModel post = widget.post;
    return BlocListener<PostsBloc, PostsState>(
      listenWhen: (previous, current) {
        if (current is PostsLoadSuccess && previous is PostsDeleteInProgress) {
          navService.pop(context);
          return false;
        } else if (previous is PostsModifyInProgress &&
            current is PostsLoadSuccess) {
          bloc.add(PostDetailModifyStarted(post: widget.post));
        }
        return true;
      },
      listener: (context, state) {},
      child: BlocProvider.value(
        value: bloc,
        child: BlocConsumer<PostDetailBloc, PostDetailState>(
          listener: (context, state) {
            if (state is PostDetailDeleteSuccess) {
              showSnackBar(context, 'Xóa bài viết thành công', Colors.green);
              _deletePostInlist(context);
              // navService.pop(context);
            } else if (state is PostDetailLoadFailure) {
              showSnackBar(context, 'Xóa bài viết thất bại', Colors.red);
            } else if (state is PostDetailLoadSuccess) {
              post = state.post;
            }
          },
          builder: (txt, state) => Scaffold(
            body: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor:
                      _isPinned ? kPrimaryColor : Colors.transparent,
                  elevation: 0,
                  expandedHeight: size.height * 0.3,
                  pinned: true,
                  title: _isPinned
                      ? AnimatedOpacity(
                          duration: const Duration(milliseconds: 300),
                          opacity: 1.0,
                          child: Text(
                            '${post.title}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                  flexibleSpace: FlexibleSpaceBar(
                    background: BlocBuilder<PostDetailBloc, PostDetailState>(
                      builder: (context, state) {
                        final image = state is PostDetailLoadSuccess
                            ? state.post.image
                            : post.image;
                        return CustomImageView(
                          url: image,
                          width: size.width,
                          height: size.height * 0.3,
                        );
                      },
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        _handleBottomSheet(txt);
                      },
                      icon: const Icon(Icons.more_vert),
                    )
                  ],
                ),
                SliverToBoxAdapter(
                  child: switch (post.type) {
                    PostType.event =>
                      ContentEventsDetail(post: post as EventModel),
                    PostType.news =>
                      ContentNewsDetails(post: post as NewsModel),
                    _ => ContentNewsDetails(post: widget.post),
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
