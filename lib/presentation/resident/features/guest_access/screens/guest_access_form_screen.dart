import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/guest_access/guest_access.dart';
import 'package:social_network/presentation/resident/features/guest_access/blocs/guest_access/guest_access_bloc.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/utils.dart';

class GuestAccessFormScreen extends StatefulWidget {
  const GuestAccessFormScreen({super.key});

  @override
  State<GuestAccessFormScreen> createState() => _GuestAccessFormScreenState();
}

class _GuestAccessFormScreenState extends State<GuestAccessFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _guestNameController = TextEditingController();
  final _guestPhoneController = TextEditingController();
  final _guestCccdController = TextEditingController();
  final _purposeController = TextEditingController();
  final _expectedTimeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _guestPhoneController.dispose();
    _guestCccdController.dispose();
    _purposeController.dispose();
    _expectedTimeController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký khách thăm'),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<GuestAccessBloc, GuestAccessState>(
          listener: (context, state) {
            if (state.statusProcess == GuestAccessStatus.loaded) {
              showSnackBarSuccess(context, 'Tạo phiếu đăng ký thành công');
              navService.pop(context);
            } else if (state.statusProcess == GuestAccessStatus.error) {
              showSnackBarError(context, 'Tạo phiếu đăng ký thất bại');
            }
          },
          builder: (context, state) {
            bool isLoading = state.statusProcess == GuestAccessStatus.loading;
            return Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Text('sas'),
                  CustomTextFormField(
                    controller: _guestNameController,
                    hintText: 'Tên khách',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên khách';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _guestPhoneController,
                    textInputType: TextInputType.phone,
                    hintText: 'Số điện thoại',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số điện thoại';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    controller: _guestCccdController,
                    textInputType: TextInputType.number,
                    hintText: 'Số CCCD',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập số CCCD';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  PickerDateInput(
                    context,
                    controller: _expectedTimeController,
                    title: 'Thời gian dự kiến',
                    onDateSelected: (date) {
                      _expectedTimeController.text = TextFormat.formatDate(
                        date,
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomTextFormField(
                    maxLines: 5,
                    controller: _purposeController,
                    hintText: 'Mục đích',
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mục đích';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: CustomButton(
                      title: 'Tạo phiếu đăng ký',
                      isDisable: isLoading,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          GuestAccess guestAccess = GuestAccess(
                            guestName: _guestNameController.text,
                            guestPhone: _guestPhoneController.text,
                            guestCccd: _guestCccdController.text,
                            purpose: _purposeController.text,
                            expectedTime: TextFormat.parseJsonFormat(
                                _expectedTimeController.text),
                          );
                          context.read<GuestAccessBloc>().add(
                                GuestAccessCreateSubmit(guestAccess),
                              );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
