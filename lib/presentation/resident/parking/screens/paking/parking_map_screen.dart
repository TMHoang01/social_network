import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/my_vehicle/vehicle_list_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/parking/parking_bloc.dart';
import 'package:social_network/presentation/resident/parking/domain/model/parking_lot.dart';
import 'package:social_network/presentation/resident/parking/screens/paking/widgets/parking_slot_widget.dart';
import 'package:social_network/presentation/widgets/widgets.dart';
import 'package:social_network/utils/utils.dart';

class ParkingMapScreen extends StatefulWidget {
  const ParkingMapScreen({super.key});

  @override
  State<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends State<ParkingMapScreen> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void initState() {
    super.initState();
    context.read<ParkingBloc>().add(ParkingStarted());
    final myVehicleBloc = context.read<MyVehicleBloc>();
    if (myVehicleBloc.state.status == MyVehicleStatus.initial) {
      myVehicleBloc.add(MyVehicleStarted());
    }
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  final imgWight = 406.7;
  final imgHeight = 240.8;

  Map<String, List<ParkingLot>> mapSlot = {};
  Map<String, int> mapCountSlot = {};
  String? zoneSelect;

  void moveCenter(Offset point) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = screenWidth * imgHeight / imgWight;
    // double screenWidth = 406.7;
    // double screenHeight = 240.8;

    // double dx = newCenter.dx - screenWidth / 2;
    // double dy = newCenter.dy - screenHeight / 2;

    final scale = 3.0;

    final newCenter =
        getNewCenter(point.dx, point.dy, scale, screenWidth, screenHeight);
    final double xOffset = -(newCenter.dx * scale) + screenWidth / 2;
    final double yOffset = -(newCenter.dy * scale) + screenHeight / 2;
    _transformationController.value = Matrix4.identity()
      ..translate(xOffset, yOffset)
      ..scale(scale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bản đồ bãi đỗ xe'),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<ParkingBloc, ParkingState>(
          listener: (context, state) {
            if (state.status == ParkingStatus.error) {
              showSnackBarWarning(context, 'Có lỗi xảy ra');
            } else if (state.lotSelect != null) {
              moveCenter(Offset(state.lotSelect!.x, state.lotSelect!.y));
            }
          },
          buildWhen: (previous, current) {
            if (previous.status == ParkingStatus.loaded &&
                current.status == ParkingStatus.modify) {
              return false;
            }
            if (previous.lotSelect != null && current.lotSelect == null) {
              print('lotSelect null');
              context.read<MyVehicleBloc>().add(MyVehicleStarted());
            }
            return previous.status != current.status ||
                previous.lotSelect != current.lotSelect;
          },
          builder: (context, statePaking) {
            Widget child = const SizedBox();

            if (statePaking.status == ParkingStatus.loading) {
              child = const Center(child: CircularProgressIndicator());
            }
            if (statePaking.status == ParkingStatus.error) {
              child = const Center(child: Text('Có lỗi xảy ra'));
            } else if (statePaking.status == ParkingStatus.loaded) {
              mapSlot = {};
              mapCountSlot = {};
              for (var element in statePaking.list) {
                final zone = element.zone;
                if (mapSlot.containsKey(zone)) {
                  mapSlot[zone]!.add(element);

                  if (element.isAvailable) {
                    mapCountSlot[zone] = mapCountSlot[zone]! + 1;

                    // if (map[element.zone]!.contains(element.slot)) {
                    //   print('contain ${element.zone} ${element.slot}');
                    // }
                  }
                } else {
                  mapSlot[zone] = [element];
                  mapCountSlot[zone] = 1;
                }
              }

              child = Stack(
                children: [
                  Image.asset(
                    ImageConstant.imgMapF1,
                  ),
                  ...statePaking.list.map((slot) {
                    return PakingSlotWidget(slot);
                  }),
                ],
              );
            }

            child = Stack(
              children: [
                Image.asset(
                  ImageConstant.imgMapF1,
                ),
                child,
              ],
            );

            return Column(
              children: [
                const SizedBox(height: 10),
                Center(
                  child: InteractiveViewer(
                    transformationController: _transformationController,
                    // panEnabled: true,
                    minScale: 0.1,
                    maxScale: 6.0,
                    child: child,
                  ),
                ),
                if (statePaking.lotSelect != null) const SizedBox(height: 10),
                // Text('Đã chọn: ${statePaking.lotSelect?.slot}'),
                const SizedBox(height: 16),
                if (statePaking.status == ParkingStatus.loaded) ...[
                  Text(
                    'Hầm để xe F${statePaking.list[0].floor}',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  StatefulBuilder(builder: (context, setState) {
                    return Column(
                      children: [
                        Center(
                          child: Wrap(
                            spacing: 10.0,
                            runSpacing: 10.0,
                            children: mapSlot.keys.map(
                              (key) {
                                return InkWell(
                                  onTap: () {
                                    setState(() {
                                      zoneSelect = key;
                                      // final lot not ticketId first
                                      final lot = mapSlot[key]!.firstWhere(
                                          (element) =>
                                              element.ticketId == null);
                                      if (lot != null) {
                                        context
                                            .read<ParkingBloc>()
                                            .add(ParkingSelectLot(lot));
                                        moveCenter(Offset(lot.x, lot.y));
                                      }
                                    });
                                  },
                                  child: Container(
                                    width: 80,
                                    height: 56,
                                    color: mapCountSlot[key]! > 0
                                        ? Colors.green
                                        : Colors.red,
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '$key',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          Text(
                                            '${mapCountSlot[key]}/${mapSlot[key]!.length}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }),
                ],
                const SizedBox(height: 10),
                Column(
                  children: [
                    BlocBuilder<MyVehicleBloc, MyVehicleState>(
                      builder: (context, stateVehicle) {
                        Widget parkingSlotSelect = Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child:
                                  Text('Slot: ${statePaking.lotSelect?.name}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      )),
                            ),
                            // Expanded(child: Container()),
                            // Expanded(
                            //   child: CustomButton(
                            //     onPressed: () {
                            //       // context.read<ParkingBloc>().add(
                            //       //     ParkingInProccess(
                            //       //         state.lotSelect!, zoneSelect!));
                            //     },
                            //     title: 'Xác nhận',
                            //   ),
                            // ),
                          ],
                        );

                        Widget listVehicle = const SizedBox();

                        if (stateVehicle.status == MyVehicleStatus.loading ||
                            stateVehicle.status == MyVehicleStatus.initial) {
                          listVehicle = const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (stateVehicle.status ==
                            MyVehicleStatus.error) {
                          listVehicle = const Center(
                            child: Text('Có lỗi xảy ra'),
                          );
                        } else if (stateVehicle.list.isEmpty) {
                          listVehicle = const Center(
                            child: Text('Không có dữ liệu'),
                          );
                        } else {
                          listVehicle = Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: stateVehicle.listActive.length,
                              itemBuilder: (context, index) {
                                final item = stateVehicle.listActive[index];

                                return InkWell(
                                  onTap: () {
                                    if (item.parkingLotId != null) {
                                      // final lot = statePaking.list.firstWhere(
                                      //     (element) =>
                                      //         element.id == item.ticketId);
                                      context
                                          .read<ParkingBloc>()
                                          .add(ParkingSelectVehicle(item));
                                    } else {
                                      showSnackBarWarning(context,
                                          'Không tìm thấy xe trong bãi đỗ');
                                    }
                                  },
                                  child: Card(
                                    child: ListTile(
                                      leading: CircleAvatar(
                                          child: Icon(item.vehicleType == 'car'
                                              ? Icons.directions_car
                                              : Icons.motorcycle)),
                                      title:
                                          Text(item.vehicleLicensePlate ?? ""),
                                      subtitle: Text(
                                        item.parkingLotName ?? '',
                                        style: const TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: item.parkingLotId == null
                                          // ? const CustomCircleButton(
                                          //     margin: EdgeInsets.zero,
                                          //     iconSize: 36,
                                          //     icon: Icons.check_circle,
                                          //     color: Colors.green,
                                          //   )
                                          ? SizedBox(
                                              width: 120,
                                              child: CustomButton(
                                                isDisable: statePaking
                                                    .disableLotSelect,
                                                margin: EdgeInsets.zero,
                                                height: 36,
                                                onPressed: () {
                                                  context
                                                      .read<ParkingBloc>()
                                                      .add(ParkingInProccess(
                                                          statePaking
                                                              .lotSelect!,
                                                          item));
                                                },
                                                title: 'Đỗ xe',
                                              ),
                                            )
                                          : SizedBox(
                                              width: 120,
                                              child: CustomButton(
                                                isDisable: statePaking
                                                            .lotSelect ==
                                                        null ||
                                                    statePaking.lotSelect?.id !=
                                                        item.parkingLotId,
                                                backgroundColor:
                                                    kSecondaryColor,
                                                margin: EdgeInsets.zero,
                                                height: 36,
                                                onPressed: () {
                                                  context
                                                      .read<ParkingBloc>()
                                                      .add(
                                                        ParkingOutProccess(
                                                          statePaking
                                                              .lotSelect!,
                                                        ),
                                                      );
                                                },
                                                title: 'Lấy xe',
                                              ),
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              if (statePaking.lotSelect != null)
                                parkingSlotSelect,
                              listVehicle,
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Offset getNewCenter(
      double dx, double dy, double scale, double width, double height) {
    Offset ponitA = Offset(width / scale / 2, height / scale / 2);
    Offset ponitB = Offset(width - width / scale / 2, height / scale / 2);
    Offset ponitD = Offset(width / scale / 2, height - height / scale / 2);
    Offset ponitC =
        Offset(width - width / scale / 2, height - height / scale / 2);

    Offset point = Offset(dx, dy);

    if (point.dx > ponitA.dx &&
        point.dx < ponitB.dx &&
        point.dy > ponitA.dy &&
        point.dy < ponitD.dy) {
      return point;
    }

    if (point.dx < ponitA.dx && point.dy < ponitA.dy) {
      return ponitA;
    }

    if (point.dx > ponitB.dx && point.dy < ponitB.dy) {
      return ponitB;
    }

    if (point.dx > ponitC.dx && point.dy > ponitC.dy) {
      return ponitC;
    }

    if (point.dx < ponitD.dx && point.dy > ponitD.dy) {
      return ponitD;
    }
    if (point.dx < ponitA.dx) {
      return Offset(ponitA.dx, point.dy);
    }
    if (point.dx > ponitB.dx) {
      return Offset(ponitB.dx, point.dy);
    }
    if (point.dy < ponitA.dy) {
      return Offset(point.dx, ponitA.dy);
    }
    if (point.dy > ponitD.dy) {
      return Offset(point.dx, ponitD.dy);
    }
    return Offset(width / 2, height / 2);
  }
}
