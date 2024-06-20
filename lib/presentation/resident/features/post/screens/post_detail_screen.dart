import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/news.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/resident/features/post/blocs/post_detail/post_detail_bloc.dart';
import 'package:social_network/presentation/resident/features/post/screens/widgets/content_event_detail.dart';
import 'package:social_network/presentation/resident/features/post/screens/widgets/content_news_detail.dart';
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
  late PostModel post = widget.post;
  final ScrollController _scrollController = ScrollController();
  bool _isPinned = false;
  final double _expandedHeight = 200;
  final bloc = sl.get<PostViewDetailBloc>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // logger.d('offset: ${_scrollController.offset}');
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

    bloc.add(PostDetailLoadStarted(post: widget.post));
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider.value(
      value: bloc,
      child: BlocConsumer<PostViewDetailBloc, PostViewDetailState>(
        listener: (context, state) {
          if (state is PostDetailLoadFailure) {
            showSnackBar(context, state.message,
                state.warning == true ? Colors.blue : Colors.red);
          } else if (state is PostDetailLoadSuccess) {
            setState(() {
              post = state.post;
            });
          }
        },
        builder: (txt, state) => Scaffold(
          body: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                backgroundColor: _isPinned ? kPrimaryColor : Colors.transparent,
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
                  background:
                      BlocBuilder<PostViewDetailBloc, PostViewDetailState>(
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
                  PostType.news => ContentNewsDetails(post: post as NewsModel),
                  _ => ContentNewsDetails(post: widget.post as NewsModel),
                },
              ),
            ],
          ),
          // bottomNavigationBar: post.type == PostType.event
          //     ? Padding(
          //         padding: EdgeInsets.zero,
          //         child: CustomButton(
          //             height: 54.0,
          //             title: 'Tham gia',
          //             onPressed: () {
          // bloc.add(
          //   PostJoinEvent(post: post as EventModel),
          // );
          //             }),
          //       )
          //     : null,
        ),
      ),
    );
  }
}
