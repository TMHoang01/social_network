import 'package:social_network/presentation/resident/parking/data/vehicle_remote.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';

abstract class VehicleRepository {
  Future<List<VehicleTicket>> getMyVehicles(String userId);
  Future<VehicleTicket> getVehicle(String id);
  Future<VehicleTicket> addVehicle(VehicleTicket vehicle);
  Future<VehicleTicket> updateVehicle(VehicleTicket vehicle);
  Future<void> deleteVehicle(String id);
}

class VehicleRepositoryImpl implements VehicleRepository {
  VehicleRemoteDataSource vehicleRemoteDataSource;

  VehicleRepositoryImpl(this.vehicleRemoteDataSource);

  @override
  Future<List<VehicleTicket>> getMyVehicles(String userId) {
    return vehicleRemoteDataSource.getMyVehicles(userId);
  }

  @override
  Future<VehicleTicket> getVehicle(String id) {
    return vehicleRemoteDataSource.getVehicle(id);
  }

  @override
  Future<VehicleTicket> addVehicle(VehicleTicket vehicle) {
    return vehicleRemoteDataSource.addVehicle(vehicle);
  }

  @override
  Future<VehicleTicket> updateVehicle(VehicleTicket vehicle) {
    return vehicleRemoteDataSource.updateVehicle(vehicle);
  }

  @override
  Future<void> deleteVehicle(String id) {
    return vehicleRemoteDataSource.deleteVehicle(id);
  }
}
