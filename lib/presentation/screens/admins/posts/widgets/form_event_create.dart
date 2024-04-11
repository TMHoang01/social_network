import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/post/event.dart';
import 'package:social_network/domain/models/post/post.dart';
import 'package:social_network/presentation/blocs/admins/post_create/post_create_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class FormEventCreate extends StatefulWidget {
  FormEventCreate({super.key});

  @override
  State<FormEventCreate> createState() => _FormEventCreateState();
}

class _FormEventCreateState extends State<FormEventCreate> {
  final _keyForm = GlobalKey<FormState>();
  final _typePost = PostType.event;
  final _imageController = TextEditingController();
  final _titleController = TextEditingController(text: 'Sự kiện');
  final _contentController = TextEditingController(text: 'Nội dung sự kiện');
  final _localtionController = TextEditingController(text: 'Địa điểm tổ chức');
  final _maxJoinersController = TextEditingController(text: '100');
  final _beginDateController =
      TextEditingController(text: TextFormat.formatDate(DateTime.now()));
  final _endDateController =
      TextEditingController(text: TextFormat.formatDate(DateTime.now()));
  late String? id;
  bool _showLimitInput = false;
  bool _isPublic = true;

  @override
  void initState() {
    super.initState();
    final bloc = context.read<PostCreateBloc>().state;
    if (bloc is PostEditStarting) {
      final post = bloc.post as EventModel;
      id = post.id;
      _titleController.text = post.title ?? '';
      _contentController.text = post.content ?? '';
      _localtionController.text = post.location ?? '';
      _maxJoinersController.text = post.maxJoiners?.toString() ?? '100';
      _beginDateController.text =
          TextFormat.formatDate(post.beginDate ?? DateTime.now());
      _endDateController.text =
          TextFormat.formatDate(post.endDate ?? DateTime.now());
      _showLimitInput = post.limitJoiners ?? false;
    }
  }

  @override
  void dispose() {
    _imageController.dispose();
    _titleController.dispose();
    _contentController.dispose();
    _localtionController.dispose();
    _maxJoinersController.dispose();
    _beginDateController.dispose();
    _endDateController.dispose();

    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    if (!_keyForm.currentState!.validate()) {
      showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
      return;
    }
    //else if (_imageController.text.isEmpty) {
    //   showSnackBar(context, 'Vui lòng chọn ảnh', Colors.red);
    //   return;
    // }
    else {
      final post = EventModel(
        title: _titleController.text,
        content: _contentController.text,
        type: _typePost,
        location: _localtionController.text,
        beginDate: TextFormat.parseDate(_beginDateController.text),
        endDate: TextFormat.parseDate(_endDateController.text),
        limitJoiners: _showLimitInput,
        maxJoiners:
            _showLimitInput ? int.parse(_maxJoinersController.text) : null,
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

            BlocBuilder<PostCreateBloc, PostCreateState>(
              builder: (context, state) {
                if (state is PostEditStarting) {
                  final post = state.post as EventModel;
                }
                return ImageInputPiker(
                  url: state is PostEditStarting
                      ? (state.post as EventModel).image
                      : null,
                  onFileSelected: (file) {
                    _imageController.text = file!.path;
                  },
                );
              },
            ),
            const SizedBox(height: 12),

            CustomTextFormField(
              controller: _titleController,
              hintText: 'Nhập tiêu đề',
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: PickerDateInput(
                      context,
                      title: 'Bắt đầu',
                      controller: _beginDateController,
                      onDateSelected: (date) {
                        // _dates = date;
                        _beginDateController.text = TextFormat.formatDate(date);
                      },
                      margin: const EdgeInsets.only(top: 4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: PickerDateInput(
                      context,
                      title: 'Kết thúc',
                      controller: _endDateController,
                      onDateSelected: (date) {
                        _endDateController.text = TextFormat.formatDate(date);
                      },
                      margin: const EdgeInsets.only(top: 4),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _localtionController,
              hintText: 'Địa điểm',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa điểm tổ chức';
                }
                return null;
              },
            ),

            Padding(
              padding: const EdgeInsets.only(left: 10, right: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _showLimitInput,
                    onChanged: (value) {
                      setState(() {
                        _showLimitInput = value!;
                      });
                    },
                  ),
                  const Text('Giới hạn số lượng người tham gia'),
                ],
              ),
            ),
            if (_showLimitInput)
              Column(
                children: [
                  CustomTextFormField(
                    controller: _maxJoinersController,
                    hintText: 'Số lượng giới hạn',
                    textInputType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số lượng người tham gia';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                ],
              ),

            const SizedBox(height: 16),
            submitButton,
          ],
        ),
      ),
    );
  }
}
