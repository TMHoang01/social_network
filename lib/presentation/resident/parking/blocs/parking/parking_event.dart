part of 'parking_bloc.dart';

sealed class ParkingEvent extends Equatable {
  const ParkingEvent();

  @override
  List<Object> get props => [];
}

class ParkingStarted extends ParkingEvent {}

class ParkingUpdateSlot extends ParkingEvent {
  final List<ParkingLot> list;
  const ParkingUpdateSlot({required this.list});

  @override
  List<Object> get props => [list];
}

class ParkingSelectLot extends ParkingEvent {
  final ParkingLot lot;
  const ParkingSelectLot(this.lot);

  @override
  List<Object> get props => [lot];
}

class ParkingSelectVehicle extends ParkingEvent {
  final VehicleTicket ticket;
  const ParkingSelectVehicle(this.ticket);

  @override
  List<Object> get props => [ticket];
}

class ParkingInProccess extends ParkingEvent {
  final ParkingLot lot;
  final VehicleTicket ticket;
  const ParkingInProccess(this.lot, this.ticket);

  @override
  List<Object> get props => [lot, ticket];
}

class ParkingOutProccess extends ParkingEvent {
  final ParkingLot lot;
  const ParkingOutProccess(this.lot);

  @override
  List<Object> get props => [lot];
}
