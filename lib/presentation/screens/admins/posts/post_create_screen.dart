import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/screens/admins/posts/widgets/form_event_create.dart';
import 'package:social_network/presentation/screens/admins/posts/widgets/form_news_create.dart';

class PostCreateScreen extends StatefulWidget {
  final PostCreateBloc _postCreateBloc;
  const PostCreateScreen({Key? key, required PostCreateBloc bloc})
      : _postCreateBloc = bloc,
        super(key: key);

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  late final _typePost = switch (widget._postCreateBloc.state) {
    // PostInsertStarted(post: final post) => post.type,
    PostCreateStarting(type: final type) => type,
    PostEditStarting(post: final post) => post.type,
    _ => PostType.news,
  };

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget child = switch (_typePost) {
      PostType.event => FormEventCreate(),
      PostType.news => const FormNewsCreate(),
      _ => const FormNewsCreate(),
    };
    child = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Tạo bài đăng ${_typePost}'),
      ),
      body: BlocProvider.value(
        value: widget._postCreateBloc,
        child: SingleChildScrollView(child: child),
      ),
    );
    return child;
  }
}
