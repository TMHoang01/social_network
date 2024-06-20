import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/my_vehicle/vehicle_list_bloc.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';
import 'package:social_network/presentation/widgets/custom_button.dart';
import 'package:social_network/presentation/widgets/custom_input.dart';
import 'package:social_network/presentation/widgets/select_widget.dart';
import 'package:social_network/presentation/widgets/show_snackbar.dart';
import 'package:social_network/utils/utils.dart';

class FormResgitterVehicleScreen extends StatefulWidget {
  const FormResgitterVehicleScreen({super.key});

  @override
  State<FormResgitterVehicleScreen> createState() =>
      _FormResgitterVehicleScreenState();
}

class _FormResgitterVehicleScreenState
    extends State<FormResgitterVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _licensePlateController = TextEditingController(text: '37BA-00121');
  final _vehicleTypeController = TextEditingController();
  final _brandController = TextEditingController(text: 'Honda');
  final _ownerController = TextEditingController(text: 'Nguyễn Văn A');
  @override
  void dispose() {
    _licensePlateController.dispose();
    _vehicleTypeController.dispose();
    _brandController.dispose();
    _ownerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const sizebox = SizedBox(height: 12);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Đăng ký thẻ gửi xe'),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: BlocConsumer<MyVehicleBloc, MyVehicleState>(
          listener: (context, state) {
            if (state.createStatus == MyVehicleCreateStatus.loaded) {
              showSnackBarSuccess(context, 'Đăng ký thành công');
              Navigator.of(context).pop();
            }
            if (state.createStatus == MyVehicleCreateStatus.error) {
              showSnackBarError(context, 'Đăng ký thất bại');
            }
          },
          builder: (context, state) {
            bool isLoading =
                state.createStatus == MyVehicleCreateStatus.loading;
            return Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizebox,
                  // CustomTextFormField(
                  //   controller: _vehicleTypeController,
                  //   hintText: 'Loại xe',
                  //   validator: (value) => Validators.validateEmpty(value),
                  // ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Text(
                      'Loại xe',
                      style: TextStyle(
                        fontSize: 16.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: StatefulBuilder(
                        builder: (BuildContext ctx, StateSetter setState) {
                      return Row(
                        children: [
                          Expanded(
                            child: SelectWidget(
                              text: 'Xe máy',
                              warp: true,
                              isSelect:
                                  _vehicleTypeController.text == 'motorbike',
                              onChanged: () {
                                setState(() {
                                  _vehicleTypeController.text = 'motorbike';
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: SelectWidget(
                              text: 'Ô tô',
                              warp: true,
                              isSelect: _vehicleTypeController.text == 'car',
                              onChanged: () {
                                setState(() {
                                  _vehicleTypeController.text = 'car';
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }),
                  ),
                  // sizebox,
                  // CustomTextFormField(
                  //   controller: _colorController,
                  //   hintText: 'Màu xe',
                  //   validator: (value) => Validators.validateEmpty(value),
                  // ),
                  sizebox,
                  CustomTextFormField(
                    controller: _brandController,
                    hintText: 'Hãng xe',
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,
                  CustomTextFormField(
                    controller: _licensePlateController,
                    hintText: 'Biển số xe',
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,
                  CustomTextFormField(
                    controller: _ownerController,
                    hintText: 'Chủ sở hữu',
                    validator: (value) => Validators.validateEmpty(value),
                  ),
                  sizebox,
                  CustomButton(
                    onPressed: () {
                      if (isLoading) {
                        return;
                      }
                      if (_vehicleTypeController.text.isEmpty) {
                        showSnackBarWarning(context, 'Vui lòng chọn loại xe');
                        return;
                      }

                      if (_formKey.currentState!.validate()) {
                        // submit
                        final vehicle = VehicleTicket(
                          vehicleLicensePlate: _licensePlateController.text,
                          vehicleType: _vehicleTypeController.text,
                          vehicleBarnd: _brandController.text,
                          vehicleOwner: _ownerController.text,
                          createdAt: DateTime.now(),
                        );
                        context
                            .read<MyVehicleBloc>()
                            .add(MyVehicleCreate(vehicle: vehicle));
                      }
                    },
                    title: 'Đăng ký',
                    prefixWidget: isLoading
                        ? Transform.scale(
                            scale: 0.5,
                            child: const CircularProgressIndicator(),
                          )
                        : null,
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
