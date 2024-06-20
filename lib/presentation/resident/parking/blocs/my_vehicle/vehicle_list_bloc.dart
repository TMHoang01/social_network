import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';
import 'package:social_network/presentation/resident/parking/domain/repository/vehicle_repository.dart';
import 'package:social_network/utils/utils.dart';

part 'vehicle_list_event.dart';
part 'vehicle_list_state.dart';

class MyVehicleBloc extends Bloc<MyVehicleEvent, MyVehicleState> {
  final VehicleRepository vehicleRepository;
  MyVehicleBloc(this.vehicleRepository) : super(const MyVehicleState()) {
    on<MyVehicleEvent>((event, emit) {});

    on<MyVehicleStarted>(_onMyVehicleStarted, transformer: droppable());
    on<MyVehicleCreate>(_onMyVehicleCreate, transformer: droppable());
  }

  void _onMyVehicleStarted(
    MyVehicleStarted event,
    Emitter<MyVehicleState> emit,
  ) async {
    emit(state.copyWith(status: MyVehicleStatus.loading));
    try {
      final userId = userCurrent?.uid ?? '';
      final list = await vehicleRepository.getMyVehicles(userId);
      emit(state.copyWith(status: MyVehicleStatus.loaded, list: list));
    } catch (e) {
      emit(state.copyWith(status: MyVehicleStatus.error));
    }
  }

  void _onMyVehicleCreate(
    MyVehicleCreate event,
    Emitter<MyVehicleState> emit,
  ) async {
    emit(state.copyWith(createStatus: MyVehicleCreateStatus.loading));
    try {
      final userId = userCurrent?.uid ?? '';
      final vehicle =
          event.vehicle.copyWith(userId: userId, status: TicketStatus.pending);
      final newVehicle = await vehicleRepository.addVehicle(vehicle);
      // delay 2s
      await Future.delayed(const Duration(seconds: 1));
      final list = [
        ...state.list,
        newVehicle,
      ];

      emit(
        state.copyWith(createStatus: MyVehicleCreateStatus.loaded, list: list),
      );
    } catch (e) {
      emit(
        state.copyWith(
          createStatus: MyVehicleCreateStatus.error,
          message: e.toString(),
        ),
      );
    }
  }
}
