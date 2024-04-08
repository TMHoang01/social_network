import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/presentation/blocs/auth/auth_bloc.dart';
import 'package:social_network/presentation/blocs/user_infor/user_infor_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/utils.dart';

class ProviderFormWidget extends StatefulWidget {
  const ProviderFormWidget({super.key});

  @override
  State<ProviderFormWidget> createState() => _ProviderFormWidgetState();
}

class _ProviderFormWidgetState extends State<ProviderFormWidget> {
  final _keyForm = GlobalKey<FormState>();

  final _titleController = TextEditingController();

  final _descControler =
      TextEditingController(text: 'Của hàng chyên cung cấp thực phẩm sạch');
  final _adressController =
      TextEditingController(text: 'Số 1, ngõ 1, phố 1, quận 1, Hà Nội');
  final _fileController = TextEditingController();
  final _userNameController = TextEditingController(text: 'Hoangf tm');
  final _phoneController = TextEditingController(text: '0987654321');

  @override
  void dispose() {
    _titleController.dispose();
    _descControler.dispose();
    _fileController.dispose();
    _userNameController.dispose();
    _phoneController.dispose();
    _adressController.dispose();

    super.dispose();
  }

  void _handleSubmit(BuildContext context) {
    bool isValidate = _keyForm.currentState!.validate();
    if (!isValidate) {
      return;
    }
    if (_fileController.text.isEmpty) {
      showSnackBar(context, 'Vui lòng chọn ảnh', Colors.red);
      return;
    }
    final user = UserModel(
      username: _userNameController.text,
      phone: _phoneController.text,
      address: _adressController.text,
    );
    context
        .read<UserInforBloc>()
        .add(UserInforUpdateInfor(avatar: _fileController.text, user: user));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Form(
        key: _keyForm,
        child: Column(
          children: [
            // image,

            ImageInputPiker(
              url: _fileController.text,
              onFileSelected: (file) {
                _fileController.text = file!.path;
              },
            ),
            const SizedBox(height: 16),

            CustomTextFormField(
              controller: _userNameController,
              hintText: 'Tên nhà cung cấp',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            CustomTextFormField(
              controller: _phoneController,
              hintText: 'Số điện thoại',
              textInputType: TextInputType.phone,
              validator: (value) {
                return Validators.validatePhoneNumber(value);
              },
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _adressController,
              hintText: 'Địa chỉ',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập địa chỉ';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            CustomTextFormField(
              controller: _descControler,
              maxLines: 5,
              hintText: 'Nhập nội dung bài viết',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nội dung';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            CustomButton(
              title: 'Xác nhận',
              onPressed: () {
                _handleSubmit(context);
              },
            ),
            BlocConsumer<UserInforBloc, UserInforState>(
              listener: (context, state) {
                if (state is UserInforUpdateInforSuccess) {
                  context.read<AuthBloc>()..add(CheckAuthRequested());
                }
              },
              builder: (context, state) {
                bool isLoading = (state is UserInforUpdateInforLoading);
                return CustomButton(
                  onPressed: () {
                    if (isLoading) return;
                    if (_keyForm.currentState!.validate()) {
                      _handleSubmit(context);
                    } else {
                      showSnackBar(
                          context, 'Vui lòng điền dủ thông tin', Colors.red);
                    }
                  },
                  title: 'Xác nhận',
                  prefixWidget: isLoading
                      ? Transform.scale(
                          scale: 0.5,
                          child: const CircularProgressIndicator(),
                        )
                      : null,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
