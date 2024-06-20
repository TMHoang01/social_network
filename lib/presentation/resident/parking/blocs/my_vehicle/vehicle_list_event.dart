part of 'vehicle_list_bloc.dart';

sealed class MyVehicleEvent extends Equatable {
  const MyVehicleEvent();

  @override
  List<Object> get props => [];
}

class MyVehicleStarted extends MyVehicleEvent {}

class MyVehicleCreate extends MyVehicleEvent {
  final VehicleTicket vehicle;
  const MyVehicleCreate({required this.vehicle});

  @override
  List<Object> get props => [vehicle];
}

class MyVehicleOutParking extends MyVehicleEvent {
  final VehicleTicket id;
  const MyVehicleOutParking({required this.id});

  @override
  List<Object> get props => [id];
}
