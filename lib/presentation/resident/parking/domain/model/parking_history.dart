// class hiển thị việc ra vào củ ve trong nơi để xe
import 'package:equatable/equatable.dart';

class ParkingHistory extends Equatable {
  final String? id;
  final String? ticketId;
  final String? vehicleLicensePlate;
  final String? vehicleType; // car, motorbike
  final DateTime? timeIn;
  final DateTime? timeOut;
  final String? lotId;

  ParkingHistory({
    this.id,
    this.ticketId,
    this.vehicleType,
    this.vehicleLicensePlate,
    this.lotId,
    this.timeIn,
    this.timeOut,
  });

  @override
  List<Object?> get props => [
        id,
        ticketId,
        vehicleLicensePlate,
        vehicleType,
        timeIn,
        timeOut,
        lotId,
      ];
}
