import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/provider/post/blocs/my_post_provider/my_post_provider_bloc.dart';
import 'package:social_network/presentation/provider/post/blocs/post_form/post_form_bloc.dart';
import 'package:social_network/presentation/provider/post/sreens/widgets/post_card.dart';
import 'package:social_network/presentation/provider/post/sreens/widgets/post_card_my_provider.dart';
import 'package:social_network/presentation/provider/screens/router_admin.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/logger.dart';

class MyPostProviderScreen extends StatefulWidget {
  const MyPostProviderScreen({super.key});

  @override
  State<MyPostProviderScreen> createState() => _MyPostProviderScreenState();
}

class _MyPostProviderScreenState extends State<MyPostProviderScreen> {
  @override
  void initState() {
    super.initState();
    initLoadData();
  }

  initLoadData() {
    context.read<MyPostProviderBloc>().add(MyPostProviderStarted());
  }

  final List<PostFormBloc> _postCreateBlocs = [];
  _handleNewPostBtn(BuildContext context) {
    // show bottompopup
    showBottomSheetApp(
      context: context,
      title: 'Tạo bài đăng',
      child: Column(
        children: [
          ListTile(
            title: const Text('Tạo bài viết'),
            onTap: () {
              navService.pop(context);
              _navigateToPostCreateScreen(context, PostType.news);
            },
          ),
          ListTile(
            title: const Text('Tạo sự kiện'),
            onTap: () {
              navService.pop(context);
              _navigateToPostCreateScreen(context, PostType.event);
            },
          ),
        ],
      ),
    );
  }

  void _navigateToPostCreateScreen(BuildContext context, PostType type) {
    final bloc = sl.get<PostFormBloc>()..add(PostFormCreateInit(type));
    setState(() {
      _postCreateBlocs.insert(0, bloc);
    });
    bloc.stream.listen(
      (state) {
        if (state is PostFormCreateSuccess) {
          setState(() {
            _postCreateBlocs.remove(bloc);
          });
          bloc.close();
        }
      },
    );

    navService.pushNamed(context, RouterAdmin.postAdd, args: bloc);
  }

  _handlePostReTry(PostFormBloc bloc) {
    final state = bloc.state as PostFormFailure;

    bloc.add(PostFormCreateRetryStart(
      title: state.post.title ?? '',
      content: state.post.content ?? '',
      imagePath: state.post.image ?? '',
    ));
  }

  Widget _buildFailurePost(PostFormBloc bloc) {
    final state = bloc.state as PostFormFailure;
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

  Widget _buildPendingPost(PostFormInProcess state) {
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
    final pendingPosts = _postCreateBlocs.map(
      (bloc) {
        return BlocProvider.value(
          value: bloc,
          child: BlocConsumer<PostFormBloc, PostFormState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is PostFormCreateSuccess) {
                context
                    .read<MyPostProviderBloc>()
                    .add(MyPostProviderInsertStarted(post: state.post));
              }
            },
            builder: (context, state) {
              if (state is PostFormInProcess) {
                return _buildPendingPost(state);
              } else if (state is PostFormFailure) {
                return _buildFailurePost(bloc);
              }
              return const SizedBox();
            },
          ),
        );
      },
    ).toList();

    return BlocBuilder<MyPostProviderBloc, MyPostProviderState>(
      builder: (context, state) {
        Widget wdiget = Container();
        if (state.status == MyPostProviderStatus.loading) {
          wdiget = const Center(
            child: CircularProgressIndicator(),
          );
        } else if (state.status == MyPostProviderStatus.error) {
          wdiget = Text(state.message ?? '');
        } else {
          wdiget = ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: state.list.length,
            separatorBuilder: (context, index) => const SizedBox(height: 2),
            itemBuilder: (context, index) {
              final post = state.list[index];
              return PostCardMyProviderWidget(post: post);
            },
          );
        }
        return Scaffold(
          appBar: AppBar(
            title: const Text('Danh sách bài đăng của tôi'),
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
          body: RefreshIndicator(
            onRefresh: () => Future.delayed(const Duration(seconds: 1), () {
              // print('object');
              initLoadData();
            }),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  ...pendingPosts,
                  wdiget,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
