import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/price_list.dart';
import 'package:social_network/domain/models/service/service.dart';
import 'package:social_network/presentation/blocs/admins/service_form/service_form_bloc.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/utils.dart';

class ServiceFormScreen extends StatefulWidget {
  final ServiceModel? service;
  const ServiceFormScreen({super.key, this.service});

  @override
  State<ServiceFormScreen> createState() => _ServiceFormScreenState();
}

class _ServiceFormScreenState extends State<ServiceFormScreen> {
  final ServiceFormBloc _serviceFormBloc = sl.get<ServiceFormBloc>();

  final _keyForm = GlobalKey<FormState>();
  final _imageController = TextEditingController();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController(text: 'Hoangf des');
  ServiceType? _typeController = null;
  List<PriceList> priceList = [];
  int selectType = 0;

  @override
  void dispose() {
    _keyForm.currentState?.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _imageController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    if (widget.service != null) {
      _serviceFormBloc.add(ServiceFormEditStarted());
      _titleController.text = widget.service!.title!;
      _descriptionController.text = widget.service!.description!;
      _typeController = widget.service!.type;
      priceList = [...widget.service!.priceList!];
    } else {
      _serviceFormBloc.add(ServiceFormAddStarted());
      // priceList = [PriceList()];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Tạo dịch vụ'),
      ),
      body: BlocProvider.value(
        value: _serviceFormBloc,
        child: BlocConsumer<ServiceFormBloc, ServiceFormState>(
          // bloc: _serviceFormBloc,
          listener: (context, state) {
            _handleListener(context, state);
          },
          builder: (context, state) {
            return SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(),
              child: _handleState(state),
            );
          },
        ),
      ),
    );
  }

  void _handleListener(BuildContext context, ServiceFormState state) {
    if (state is ServiceFormAddSuccess) {
      showSnackBar(context, 'Thêm dịch vụ thành công', Colors.green);
      Navigator.of(context).pop();
    } else if (state is ServiceFormAddFailure) {
      showSnackBarError(context, state.message);
    } else if (state is ServiceFormEditSuccess) {
      showSnackBar(context, 'Sửa dịch vụ thành công', Colors.green);
      Navigator.of(context).pop();
    } else if (state is ServiceFormEditFailure) {
      showSnackBarError(context, state.message);
    }
  }

  Widget _handleState(ServiceFormState state) {
    return switch (state) {
      ServiceFormAddInitial() => _formCreate(context),
      ServiceFormEditInitial() => _formCreate(context),
      ServiceFormAddSuccess() => const Center(child: Text('Success')),
      ServiceFormEditSuccess() => const Center(child: Text('Success')),
      _ => _formCreate(context),
    };
  }

  Widget _formCreate(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    ThemeData theme = Theme.of(context);
    return Form(
      key: _keyForm,
      child: Column(
        children: [
          const SizedBox(height: 20),
          ImageInputPiker(
            url: widget.service?.image ?? null,
            onFileSelected: (file) {
              _imageController.text = file!.path;
            },
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _titleController,
            hintText: 'Tên dịch vụ',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên dịch vụ';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          CustomTextFormField(
            controller: _descriptionController,
            maxLines: 5,
            textInputType: TextInputType.multiline,
            hintText: 'Mô tả',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập mô tả';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: DropdownButtonFormField<ServiceType>(
              decoration: const InputDecoration(
                // hintText: 'Chọn loại dịch vụ',
                labelText: 'Loại dịch vụ',
              ),
              iconSize: 20,
              hint: const Text('Chọn loại dịch vụ'),
              value: _typeController,
              validator: (value) =>
                  value == null ? 'Vui lòng chọn loại dịch vụ' : null,
              items: ServiceType.values
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
          Container(
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text(
                //   'Loại hình dịch vụ',
                //   style: theme.textTheme.headlineMedium!.copyWith(
                //     fontSize: 14,
                //     fontWeight: FontWeight.w700,
                //   ),
                // ),
                // StatefulBuilder(
                //   builder: (context, setState) {
                //     return SingleChildScrollView(
                //       scrollDirection: Axis.horizontal,
                //       child: Row(
                //         children: [
                //           SizedBox(
                //             width: 120,
                //             child: SelectWidget(
                //               text: 'Theo gói',
                //               isSelect: selectType == 0,
                //               onChanged: () {
                //                 setState(() {
                //                   selectType = 0;
                //                 });
                //               },
                //             ),
                //           ),
                //           SizedBox(
                //             width: 130,
                //             child: SelectWidget(
                //               text: 'Theo giờ',
                //               isSelect: selectType == 1,
                //               onChanged: () {
                //                 setState(() {
                //                   selectType = 1;
                //                 });
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                // ),
                // CustomerCheckBox(
                //   title: 'Có thể thay đổi giá sau',
                //   value: true,
                //   onChanged: (value) {},
                // ),

                Row(
                  children: [
                    Text(
                      'Bảng báo giá tham khảo',
                      style: theme.textTheme.headlineMedium!.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    CustomCircleButton(
                      icon: Icons.add,
                      iconSize: 20,
                      onPressed: () {
                        setState(() {
                          _handleAddPrice(context);
                        });
                      },
                    ),
                  ],
                ),
                SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: priceList.length,
                    itemBuilder: (context, index) {
                      PriceList price = priceList[index % priceList.length];
                      return ListTile(
                        shape: const Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.all(0),
                        title: Text('${price.name}'),
                        subtitle: Text(
                            '${TextFormat.formatMoney(price.price ?? 0)} đ'),
                        trailing: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                color: Colors.blue,
                                icon: const Icon(Icons.edit, size: 20),
                                onPressed: () {
                                  _handleAddPrice(context, price: price);
                                },
                              ),
                            ),
                            SizedBox(
                              width: 32,
                              height: 32,
                              child: IconButton(
                                color: Colors.red,
                                icon: const Icon(Icons.delete, size: 20),
                                onPressed: () {
                                  setState(() {
                                    priceList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      );

                      // return Row(
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text('${price.name} '),
                      //     Expanded(
                      //       child: CustomTextFormField(
                      //         hintText: 'Ghi chú',
                      //         margin: const EdgeInsets.only(right: 4),
                      //         initialValue: price.name,
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return '';
                      //           }
                      //           return null;
                      //         },
                      //         onChanged: (value) {
                      //           setState(() {
                      //             priceList[index] = price.copyWith(name: value);
                      //           });
                      //           _changepriceList(priceList);
                      //         },
                      //       ),
                      //     ),
                      //     const SizedBox(width: 8),
                      //     Expanded(
                      //       child: CustomTextFormField(
                      //         hintText: 'Giá',
                      //         initialValue: price.price?.toString(),
                      //         margin: const EdgeInsets.only(right: 4),
                      //         textInputType: TextInputType.number,
                      //         validator: (value) {
                      //           if (value == null || value.isEmpty) {
                      //             return '';
                      //           }
                      //           return null;
                      //         },
                      //         onChanged: (value) {
                      //           setState(() {
                      //             priceList[index] = price.copyWith(
                      //               price: double.parse(value),
                      //             );
                      //           });
                      //           _changepriceList(priceList);
                      //         },
                      //       ),
                      //     ),
                      //     Center(
                      //       child: CustomCircleButton(
                      //         icon: Icons.remove,
                      //         iconSize: 20,
                      //         onPressed: () {
                      //           setState(() {
                      //             priceList.removeAt(index);
                      //             _changepriceList(priceList);
                      //           });
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // );
                    },
                  ),
                ),
              ],
            ),
          ),
          // CustomCheckBox(
          //   title: 'Có thể thay đổi giá sau',
          //   value: true,
          //   onChanged: (value) {
          //     // setState(() {
          //     //   _showLimitInput = value!;
          //     // });
          //   },
          // ),
          const SizedBox(height: 20),
          CustomButton(
            title: 'Xác nhận',
            onPressed: () {
              _handleSubmit(context);
            },
          ),
        ],
      ),
    );
  }

  void _handleSubmit(BuildContext context) {
    if (!_keyForm.currentState!.validate()) {
      logger.d('validate fail $_typeController');
      showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
      return;
    } else if (_imageController.text.isEmpty &&
        (widget.service!.image!.isEmpty)) {
      showSnackBar(context, 'Vui lòng chọn ảnh', Colors.red);
      return;
    } else {
      ServiceModel service = ServiceModel(
        title: _titleController.text,
        description: _descriptionController.text,
        type: _typeController!,
        priceList: priceList,
      );
      if (widget.service != null) {
        service = service.copyWith(
          id: widget.service!.id,
          image: widget.service!.image,
        );
      }
      _serviceFormBloc.add(
          ServiceFormSubmit(service: service, file: _imageController.text));
    }
  }

  void _handleAddPrice(BuildContext context, {PriceList? price}) {
    // open dialog
    showDialog(
        context: context,
        builder: (context) => _dialogBuilder(context, price: price));
  }

  Widget _dialogBuilder(BuildContext context, {PriceList? price}) {
    final TextEditingController noteController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    if (price != null) {
      noteController.text = price.note ?? '';
      priceController.text = price.price?.toString() ?? '';
      nameController.text = price.name ?? '';
    }

    // Xây dựng AlertDialog
    final AlertDialog alertDialog = AlertDialog(
      title: const Text('Thêm dịch vụ'),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              margin: EdgeInsets.zero,
              controller: nameController,
              hintText: 'Tên dịch vụ',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập tên';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: priceController,
              margin: EdgeInsets.zero,
              hintText: 'Giá',
              textInputType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập giá';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            CustomTextFormField(
              controller: noteController,
              margin: EdgeInsets.zero,
              hintText: 'Ghi chú',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập ghi chú';
                }
                return null;
              },
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Hủy'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty &&
                priceController.text.isNotEmpty &&
                noteController.text.isNotEmpty) {
              final newItem = PriceList(
                name: nameController.text,
                price: double.parse(priceController.text),
                note: noteController.text,
              );
              if (price != null) {
                priceList = priceList.map((e) {
                  if (e == price) {
                    return newItem;
                  }
                  return e;
                }).toList();
              } else {
                priceList.add(newItem);
              }
              Navigator.pop(context);
            } else {
              showSnackBar(context, 'Vui lòng nhập đủ thông tin', Colors.red);
            }
          },
          child: Text(price != null ? 'Sửa' : 'Thêm'),
        ),
      ],
    );

    // Trả về AlertDialog
    return alertDialog;
  }
}
