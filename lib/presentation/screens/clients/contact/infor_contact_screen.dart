import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/blocs/clients/infor_contact/infor_contact_bloc.dart';
import 'package:social_network/presentation/widgets/custom_input.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/router.dart';
import 'package:social_network/utils/logger.dart';

class InforContactScreen extends StatefulWidget {
  const InforContactScreen({super.key});

  @override
  State<InforContactScreen> createState() => _InforContactScreenState();
}

class _InforContactScreenState extends State<InforContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _txtAddress = TextEditingController();
  final _txtPhone = TextEditingController();
  final _txtUsername = TextEditingController();
  late InforContactBloc blocContact;

  @override
  void initState() {
    super.initState();
    blocContact = context.read<InforContactBloc>();
    if (blocContact.state is! InforContactLoaded) {
      blocContact.add(GetInforContact());
    }
  }

  @override
  void dispose() {
    _txtAddress.dispose();
    _txtPhone.dispose();
    _txtUsername.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thông tin liên hệ'),
      ),
      body: BlocConsumer<InforContactBloc, InforContactState>(
        bloc: blocContact,
        listener: (context, state) {
          if (state is InforContactError) {
            showSnackBarError(context, state.message);
          } else if (state is InforContactUpdated) {
            navService.pop(context);
          }
        },
        builder: (context, state) {
          if (state is InforContactLoaded) {
            _txtAddress.text = state.inforContact.address ?? '';
            _txtPhone.text = state.inforContact.phone ?? '';
            _txtUsername.text = state.inforContact.username ?? '';
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _txtUsername,
                      hintText: 'Tên người nhận',
                      prefix: const Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập tên';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _txtPhone,
                      hintText: 'Số điện thoại',
                      prefix: const Icon(Icons.phone),
                      textInputType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập số điện thoại';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: _txtAddress,
                      hintText: 'Địa chỉ',
                      prefix: const Icon(Icons.location_on),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Vui lòng nhập địa chỉ';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      title: 'Xác nhận',
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          logger.i("onPressed save infor contact");
                          context.read<InforContactBloc>().add(
                                SaveInforContact(
                                  address: _txtAddress.text,
                                  phone: _txtPhone.text,
                                  username: _txtUsername.text,
                                ),
                              );
                        } else {
                          logger.i("onPressed save infor contact fail");
                        }
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
