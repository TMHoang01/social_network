import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/provider/post/blocs/post_form/post_form_bloc.dart';
import 'package:social_network/presentation/provider/post/sreens/widgets/form_event_create.dart';
import 'package:social_network/presentation/provider/post/sreens/widgets/form_news_create.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';

class PostCreateScreen extends StatefulWidget {
  final PostFormBloc _postFormBloc;
  const PostCreateScreen({Key? key, required PostFormBloc bloc})
      : _postFormBloc = bloc,
        super(key: key);

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  PostFormBloc? postFormBloc;

  @override
  void initState() {
    super.initState();
    postFormBloc = widget._postFormBloc;
  }

  late final typePost = switch (widget._postFormBloc.state) {
    // PostInsertStarted(post: final post) => post.type,
    PostFormCreateStarting(type: final type) => type,
    PostFormEditStarting(post: final post) => post.type,
    _ => PostType.news,
  };

  void handleSubmit(PostModel post, String image) {
    if (postFormBloc?.state is PostFormEditStarting) {
      postFormBloc?.add(
        PostFormEditStart(
          post: post,
          image: image,
        ),
      );
    } else {
      postFormBloc?.add(
        PostFormCreateStart(
          post: post,
          image: image,
        ),
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget childCreate = switch (typePost) {
      PostType.event => FormEventCreate(handleSubmit: handleSubmit),
      PostType.news => FormNewsCreate(handleSubmit: handleSubmit),
      _ => FormNewsCreate(handleSubmit: handleSubmit),
    };

    Widget child = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title:
            Text('Tạo ${typePost == PostType.event ? 'sự kiện' : 'bài viết'}'),
      ),
      body: BlocProvider.value(
        value: widget._postFormBloc,
        child: SingleChildScrollView(
          child: BlocConsumer<PostFormBloc, PostFormState>(
              listener: (context, state) {
                if (state is PostFormInProcess) {
                  navService.pop(context);
                } else if (state is PostFormCreateSuccess) {
                  showSnackBar(
                      context, 'Thêm bài đăng thành công', Colors.green);
                } else if (state is PostFormFailure) {
                  showSnackBar(context, state.error, Colors.red);
                } else if (state is PostFormEditSuccess) {
                  showSnackBar(
                      context, 'Cập nhật bài đăng thành công', Colors.green);
                } else if (state is PostEditFailure) {
                  showSnackBar(context, state.error, Colors.red);
                }
              },
              builder: (context, state) => switch (state) {
                    PostFormCreateStarting() => childCreate,
                    PostFormEditStarting(post: final post) => switch (
                          post.type) {
                        PostType.event => FormEventCreate(
                            post: post, handleSubmit: handleSubmit),
                        PostType.news => FormNewsCreate(
                            post: post, handleSubmit: handleSubmit),
                        _ => FormNewsCreate(
                            post: post, handleSubmit: handleSubmit),
                      },
                    _ => childCreate,
                  }),
        ),
      ),
    );
    return child;
  }
}
