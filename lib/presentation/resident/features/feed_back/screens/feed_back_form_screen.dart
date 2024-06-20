import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/feed_back/feed_back.dart';
import 'package:social_network/presentation/resident/features/feed_back/blocs/my_feed_back_create/my_feed_back_create_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';

class FeedBackFormScreen extends StatefulWidget {
  const FeedBackFormScreen({super.key});

  @override
  State<FeedBackFormScreen> createState() => _FeedBackFormScreenState();
}

class _FeedBackFormScreenState extends State<FeedBackFormScreen> {
  final _formKey = GlobalKey<FormState>();
  FeedBackType? _typeController;
  final _contentController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo phản ánh của bạn'),
      ),
      body: SingleChildScrollView(
        child: BlocListener<MyFeedBackCreateBloc, MyFeedBackCreateState>(
          listener: (context, state) {
            if (state is MyFeedBackCreatedSuccess) {
              showSnackBar(context, 'Tạo phản ánh thành công', Colors.green);
              Navigator.pop(context);
            } else if (state is MyFeedBackCreateError) {
              showSnackBar(context, 'Tạo phản ánh thất bại', Colors.red);
            }
          },
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<FeedBackType>(
                    decoration: const InputDecoration(
                      labelText: 'Loại khiếu nại, phản ánh',
                    ),
                    iconSize: 20,
                    hint: const Text('Loại khiếu nại, phản ánh'),
                    value: _typeController,
                    validator: (value) => value == null
                        ? 'Vui lòng chọn loại khiếu nại, phản ánh'
                        : null,
                    items: FeedBackType.values
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(' ${e.toName()}'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      _typeController = value;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                const Text('Ảnh minh chứng (nếu có)'),
                const SizedBox(height: 4),
                ImageInputPiker(
                  onFileSelected: (file) {
                    _imageController.text = file!.path;
                  },
                ),
                const SizedBox(height: 20),
                CustomTextFormField(
                  controller: _contentController,
                  hintText: 'Mô tả',
                  maxLines: 5,
                  validator: (value) =>
                      value!.isEmpty ? 'Vui lòng điền nội dung' : null,
                ),
                const SizedBox(height: 20),
                CustomButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      context.read<MyFeedBackCreateBloc>().add(
                            MyFeedBackCreateSubmit(
                              FeedBackModel(
                                type: _typeController,
                                content: _contentController.text,
                              ),
                              _imageController.text,
                            ),
                          );
                    } else {
                      showSnackBar(
                        context,
                        'Vui lòng điền đầy đủ thông tin',
                        Colors.red,
                      );
                    }
                  },
                  title: 'Gửi phản ánh',
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
