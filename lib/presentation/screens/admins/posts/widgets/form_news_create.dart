import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/news.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';

class FormNewsCreate extends StatefulWidget {
  const FormNewsCreate({super.key});

  @override
  State<FormNewsCreate> createState() => _FormNewsCreateState();
}

class _FormNewsCreateState extends State<FormNewsCreate> {
  final _keyForm = GlobalKey<FormState>();
  late String? id;
  final _titleController = TextEditingController(text: 'Hoangf');
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();
  final PostType _typePost = PostType.news;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PostCreateBloc>().state;
    if (bloc is PostEditStarting) {
      final post = bloc.post as NewsModel;
      id = post.id;
      _imageController.text = post.image ?? '';
      _titleController.text = post.title ?? '';
      _contentController.text = post.content ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _imageController.dispose();

    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (!_keyForm.currentState!.validate()) {
      showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
      return;
    }
    if (_imageController.text.isEmpty) {
      showSnackBar(context, 'Vui lòng chọn ảnh', Colors.red);
      return;
    } else {
      final post = PostModel(
        title: _titleController.text,
        content: _contentController.text,
        type: _typePost,
      );
      if (context.read<PostCreateBloc>().state is PostEditStarting) {
        context.read<PostCreateBloc>().add(
              PostEditStartEvent(
                post: post.copyWith(id: id),
                image: _imageController.text,
              ),
            );
      } else {
        context.read<PostCreateBloc>().add(
              PostCreateStartEvent(
                post: post,
                image: _imageController.text,
              ),
            );
      }
      navService.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final submitButton = CustomButton(
      title: 'Xác nhận',
      onPressed: () {
        _handleSubmit(context);
      },
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Form(
        key: _keyForm,
        child: Column(
          children: [
            // image,

            ImageInputPiker(
              url: switch (context.read<PostCreateBloc>()) {
                PostEditInitEvent(post: final post) => post.image,
                _ => null,
              },
              onFileSelected: (file) {
                _imageController.text = file!.path;
              },
            ),
            const SizedBox(height: 12),

            CustomTextFormField(
              controller: _titleController,
              hintText: 'Nhập tiêu đề bài viết',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tiêu đề';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _contentController,
              maxLines: 5,
              hintText: 'Nhập nội dung bài viết',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            submitButton,
          ],
        ),
      ),
    );
  }
}
