import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/user_model.dart';
import 'package:social_network/presentation/blocs/user_infor/user_infor_bloc.dart';
import 'package:social_network/presentation/widgets/picker_date_input.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/utils.dart';

class ResidentFormWidget extends StatefulWidget {
  const ResidentFormWidget({super.key});

  @override
  State<ResidentFormWidget> createState() => _ResidentFormWidgetState();
}

class _ResidentFormWidgetState extends State<ResidentFormWidget> {
  final _keyForm = GlobalKey<FormState>();
  final _userNameController = TextEditingController(text: 'Hoangf tm');
  final _phoneController = TextEditingController(text: '0987654321');
  final _adressController =
      TextEditingController(text: 'Khu A Chung cư 123 P123');
  final _jobController = TextEditingController(text: 'SInh vieen');
  final _dateController = TextEditingController();
  final _fileController = TextEditingController();
  DateTime _dates = DateTime.now();

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
      job: _jobController.text,
      birthDay: _dates,
    );
    context
        .read<UserInforBloc>()
        .add(UserInforUpdateInfor(avatar: _fileController.text, user: user));
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _phoneController.dispose();
    _adressController.dispose();
    _jobController.dispose();
    _dateController.dispose();
    _fileController.dispose();
    super.dispose();
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
            const SizedBox(height: 12),

            CustomTextFormField(
              controller: _userNameController,
              hintText: 'Tên cư dân',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            PickerDateInput(
              context,
              onDateSelected: (date) {
                logger.d(date);
                _dates = date;
              },
            ),
            // CustomTextFormField(
            //   hintText: 'Ngày sinh',
            //   controller: _dateController,
            //   textInputType: TextInputType.datetime,
            //   validator: (value) {
            //     if (value == null || value.isEmpty) {
            //       return 'Vui lòng nhập ngày sinh';
            //     }
            //     return null;
            //   },
            //   suffix: IconButton(
            //     icon: const Icon(Icons.calendar_today),
            //     onPressed: () {
            //       showDatePicker(
            //         context: context,
            //         initialDate: DateTime.now(),
            //         firstDate: DateTime(1900),
            //         lastDate: DateTime(2050),
            //       ).then((value) {
            //         if (value != null) {
            //           setState(() {
            //             _dates = value;
            //             _dateController.text = TextFormat.formatDate(value);
            //           });
            //         }
            //       });
            //     },
            //   ),
            // ),

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
              controller: _jobController,
              hintText: 'Nghề nghiệp',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập nghề nghiệp';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            // CustomButton(
            //   title: 'Xác nhận',
            //   onPressed: () {
            //     _handleSubmit(context);
            //   },
            // ),
            BlocBuilder<UserInforBloc, UserInforState>(
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
