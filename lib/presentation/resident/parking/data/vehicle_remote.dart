import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';

abstract class VehicleRemoteDataSource {
  Future<List<VehicleTicket>> getMyVehicles(String userId);

  Future<VehicleTicket> getVehicle(String id);

  Future<VehicleTicket> addVehicle(VehicleTicket vehicle);

  Future<VehicleTicket> updateVehicle(VehicleTicket vehicle);

  Future<void> deleteVehicle(String id);
}

class VehicleRemoteDataSourceImpl implements VehicleRemoteDataSource {
  final storage = FirebaseFirestore.instance;
  final String vehicleCollection = 'vehicles';

  @override
  Future<VehicleTicket> addVehicle(VehicleTicket vehicle) async {
    try {
      final vehicleRef =
          await storage.collection(vehicleCollection).add(vehicle.toJson());
      return vehicle.copyWith(id: vehicleRef.id);
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<void> deleteVehicle(String id) {
    // TODO: implement deleteVehicle
    throw UnimplementedError();
  }

  @override
  Future<List<VehicleTicket>> getMyVehicles(String userId) async {
    try {
      final querySnapshot = await storage
          .collection(vehicleCollection)
          .where('userId', isEqualTo: userId)
          .get();
      return querySnapshot.docs
          .map((e) => VehicleTicket.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      throw e;
    }
  }

  @override
  Future<VehicleTicket> getVehicle(String id) {
    // TODO: implement getVehicle
    throw UnimplementedError();
  }

  @override
  Future<VehicleTicket> updateVehicle(VehicleTicket vehicle) {
    // TODO: implement updateVehicle
    throw UnimplementedError();
  }
}
