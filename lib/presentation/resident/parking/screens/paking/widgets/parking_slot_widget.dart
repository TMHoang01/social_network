import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/my_vehicle/vehicle_list_bloc.dart';
import 'package:social_network/presentation/resident/parking/blocs/parking/parking_bloc.dart';
import 'package:social_network/presentation/resident/parking/domain/model/parking_lot.dart';

class PakingSlotWidget extends StatefulWidget {
  final ParkingLot slot;
  const PakingSlotWidget(this.slot, {super.key});

  @override
  State<PakingSlotWidget> createState() => _PakingSlotWidgetState();
}

class _PakingSlotWidgetState extends State<PakingSlotWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final radio = size.width / 406.7;
    ParkingLot slot = widget.slot.copyWith(
      x: widget.slot.x * radio,
      y: widget.slot.y * radio,
      w: widget.slot.w * radio,
      h: widget.slot.h * radio,
    );
    final listMyVehicle = context.read<MyVehicleBloc>().state.list;
    bool isBooked =
        listMyVehicle.any((element) => element.parkingLotId == widget.slot.id);

    Widget child = Container(
      width: widget.slot.w,
      height: widget.slot.h,
      color: Colors.red,
      child: Center(
        child: RotatedBox(
          quarterTurns: 3,
          child: Text(
            widget.slot.slot,
            style: const TextStyle(
                color: Colors.white, fontSize: 5, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );

    return BlocBuilder<ParkingBloc, ParkingState>(
      builder: (context, state) {
        final isSelect = state.lotSelect?.id == slot.id;
        Color bgColor = isSelect ? Colors.blue : slot.getBgColor;
        return Positioned(
          left: slot.x,
          top: slot.y,
          child: GestureDetector(
            onPanUpdate: (details) {},
            onTap: () {
              context.read<ParkingBloc>().add(ParkingSelectLot(slot));
            },
            child: Container(
              width: slot.w,
              height: slot.h,
              color: bgColor.withOpacity(0.4),
              child: Center(
                child: RotatedBox(
                  quarterTurns: slot.w > slot.h ? 0 : 3,
                  child: Text(
                    slot.name,
                    style: const TextStyle(
                      fontSize: 5,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
