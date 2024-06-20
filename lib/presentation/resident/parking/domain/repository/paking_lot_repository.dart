import 'package:social_network/presentation/resident/parking/data/parking_remote.dart';
import 'package:social_network/presentation/resident/parking/domain/model/parking_lot.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';

abstract class ParkingLotRepository {
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor);
  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot);

  Future<void> inParking(ParkingLot lot, VehicleTicket ticket);

  Future<void> outParking(ParkingLot lot);
}

class ParkingLotRepositoryImpl implements ParkingLotRepository {
  ParkingRemoteDataSource parkingRemoteDataSource;

  ParkingLotRepositoryImpl(this.parkingRemoteDataSource);

  @override
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor) async {
    return await parkingRemoteDataSource.getParkingLotsInFloor(floor);
  }

  @override
  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot) async {
    return await parkingRemoteDataSource.updateParkingLot(parkingLot);
  }

  @override
  Future<void> inParking(ParkingLot lot, VehicleTicket ticket) async {
    return await parkingRemoteDataSource.inParking(lot, ticket);
  }

  @override
  Future<void> outParking(ParkingLot lot) async {
    return await parkingRemoteDataSource.outParking(lot);
  }
}
