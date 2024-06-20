part of 'vehicle_list_bloc.dart';

enum MyVehicleStatus { initial, loading, loaded, error }

enum MyVehicleCreateStatus { initial, loading, loaded, error }

class MyVehicleState extends Equatable {
  final MyVehicleStatus status;
  final List<VehicleTicket> list;
  final String message;
  final MyVehicleCreateStatus createStatus;

  const MyVehicleState({
    this.status = MyVehicleStatus.initial,
    this.list = const <VehicleTicket>[],
    this.message = '',
    this.createStatus = MyVehicleCreateStatus.initial,
  });

  List<VehicleTicket> get listActive =>
      list.where((e) => e.status == TicketStatus.active).toList();

  MyVehicleState copyWith({
    MyVehicleStatus? status,
    List<VehicleTicket>? list,
    String? message,
    MyVehicleCreateStatus? createStatus,
  }) {
    return MyVehicleState(
      status: status ?? this.status,
      list: list ?? this.list,
      message: message ?? this.message,
      createStatus: createStatus ?? this.createStatus,
    );
  }

  @override
  List<Object> get props => [status, list, message, createStatus];
}
