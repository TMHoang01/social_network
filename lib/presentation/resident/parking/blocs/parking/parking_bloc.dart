import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/presentation/resident/parking/domain/model/parking_lot.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';
import 'package:social_network/presentation/resident/parking/domain/repository/paking_lot_repository.dart';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  final ParkingLotRepository parkingLotRepository;
  ParkingBloc(this.parkingLotRepository) : super(ParkingState()) {
    on<ParkingEvent>((event, emit) {});
    on<ParkingStarted>(_onParkingStarted, transformer: droppable());
    on<ParkingSelectLot>(_onParkingSelectLot, transformer: droppable());
    on<ParkingSelectVehicle>(_onParkingSelectVehicle, transformer: droppable());

    on<ParkingInProccess>(_onParkingInProccess, transformer: droppable());
    on<ParkingOutProccess>(_onParkingOutProccess, transformer: droppable());
  }

  String? floor = '1';

  void _onParkingStarted(
    ParkingStarted event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(
      status: ParkingStatus.loading,
      list: [],
      lotSelect: null,
      message: null,
    ));
    try {
      final list = await parkingLotRepository.getParkingLotsInFloor(floor!);
      emit(state.copyWith(status: ParkingStatus.loaded, list: list));
    } catch (e) {
      emit(state.copyWith(status: ParkingStatus.error));
    }
  }

  Future<void> _onParkingSelectLot(
    ParkingSelectLot event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(lotSelect: event.lot));
  }

  Future<void> _onParkingSelectVehicle(
    ParkingSelectVehicle event,
    Emitter<ParkingState> emit,
  ) async {
    try {
      final ticket = event.ticket;
      if (ticket.parkingFloor == null) {
        return;
      }
      if (ticket.parkingFloor != floor) {
        final list = await parkingLotRepository
            .getParkingLotsInFloor(ticket.parkingFloor ?? '1');
        final lot =
            list.firstWhere((element) => element.id == ticket.parkingLotId);

        emit(state.copyWith(lotSelect: lot, list: list));
      } else {
        final lot = state.list
            .firstWhere((element) => element.id == ticket.parkingLotId);
        emit(state.copyWith(lotSelect: lot));
      }
    } catch (e) {
      emit(state.copyWith(
        message: 'Error: ${e.toString()}',
      ));
    }
  }

  Future<void> _onParkingInProccess(
    ParkingInProccess event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(status: ParkingStatus.modify));
    try {
      final ticket = event.ticket;
      await parkingLotRepository.inParking(event.lot, event.ticket);
      emit(
        state
            .copyWith(
              status: ParkingStatus.loaded,
              list: state.list.map((e) {
                if (e.id == event.lot.id) {
                  return e.copyWith(
                    status: ParkingLotStatus.occupiedKnown,
                    vehicleLicensePlate: ticket.vehicleLicensePlate,
                    ticketId: ticket.id,
                  );
                }
                return e;
              }).toList(),
            )
            .emptyLotSelect(),
      );
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }

  Future<void> _onParkingOutProccess(
    ParkingOutProccess event,
    Emitter<ParkingState> emit,
  ) async {
    emit(state.copyWith(status: ParkingStatus.modify));
    try {
      await parkingLotRepository.outParking(event.lot);

      final index =
          state.list.indexWhere((element) => element.id == event.lot.id);
      ParkingLot lot = state.list[index].copyWith(
        status: ParkingLotStatus.available,
        vehicleLicensePlate: null,
        ticketId: null,
      );

      emit(
        state
            .copyWith(
              status: ParkingStatus.loaded,
              list: state.list..[index] = lot,
            )
            .emptyLotSelect(),
      );
    } catch (e) {
      emit(state.copyWith(message: e.toString()));
    }
  }
}
