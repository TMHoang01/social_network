import 'dart:io';

import 'package:flutter/material.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';

class PostCreateScreen extends StatefulWidget {
  final PostCreateBloc _postCreateBloc;
  const PostCreateScreen({Key? key, required PostCreateBloc bloc})
      : _postCreateBloc = bloc,
        super(key: key);

  @override
  State<PostCreateScreen> createState() => _PostCreateScreenState();
}

class _PostCreateScreenState extends State<PostCreateScreen> {
  final _keyForm = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
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
      widget._postCreateBloc.add(PostCreateStarted(
        image: _imageController.text,
        title: _titleController.text,
        content: _contentController.text,
      ));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final titleField = TextField(
    //   controller: _titleController,
    //   decoration: InputDecoration(
    //     fillColor: theme.colorScheme.surface,
    //     filled: true,
    //     border: OutlineInputBorder(
    //       // borderSide: BorderSide.none,
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    //   ),
    //   style: theme.textTheme.bodyLarge!
    //       .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
    // );
    // final contentField = TextField(
    //   controller: _contentController,
    //   maxLines: 10,
    //   decoration: InputDecoration(
    //     fillColor: theme.colorScheme.surface,
    //     filled: true,
    //     border: OutlineInputBorder(
    //       // borderSide: BorderSide.none,
    //       borderRadius: BorderRadius.circular(8),
    //     ),
    //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    //   ),
    //   style: theme.textTheme.bodyLarge!
    //       .copyWith(fontWeight: FontWeight.bold, fontSize: 20),
    // );
    final submitButton = CustomButton(
      title: 'Xác nhận',
      onPressed: () {
        _handleSubmit(context);
      },
    );

    final child = Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Form(
          key: _keyForm,
          child: Column(
            children: [
              // image,

              ImageInputPiker(
                url: _imageController.text,
                onFileSelected: (file) {
                  _imageController.text = file!.path;
                },
              ),
              const SizedBox(height: 16),

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
              const SizedBox(height: 16),
              // Expanded(child: contentField),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: _contentController,
                maxLines: 10,
                hintText: 'Nhập nội dung bài viết',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập nội dung';
                  }
                  return null;
                },
              ),
              submitButton,
            ],
          ),
        ),
      ),
    );
    return child;
  }
}
