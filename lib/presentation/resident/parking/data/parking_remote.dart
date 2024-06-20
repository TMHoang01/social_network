import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/presentation/resident/parking/domain/model/parking_lot.dart';
import 'package:social_network/presentation/resident/parking/domain/model/vehicle_ticket.dart';
import 'package:social_network/utils/utils.dart';

abstract class ParkingRemoteDataSource {
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor);

  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot);

  Future<void> inParking(ParkingLot lot, VehicleTicket ticket);

  Future<void> outParking(ParkingLot lot);
}

class ParkingRemoteDataSourceImpl implements ParkingRemoteDataSource {
  final storage = FirebaseFirestore.instance;
  final String parking = 'parking';

  @override
  Future<List<ParkingLot>> getParkingLotsInFloor(String floor) async {
    try {
      final querySnapshot = await storage
          .collection(parking)
          .where('floor', isEqualTo: floor)
          .get();
      return querySnapshot.docs
          .map((e) => ParkingLot.fromDocumentSnapshot(e))
          .toList();
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<ParkingLot> updateParkingLot(ParkingLot parkingLot) async {
    throw UnimplementedError();
  }

  @override
  Future<void> inParking(ParkingLot lot, VehicleTicket ticket) async {
    // update transaction parking lot: status, vehicleLicensePlate, and ticketId
    // and vehicle: status, parkingFloor, parkingLotId
    try {
      final response = await storage.runTransaction((transaction) async {
        final lotRef = storage.collection(parking).doc(lot.id);
        final lotDoc = await transaction.get(lotRef);
        if (!lotDoc.exists) {
          throw Exception('Vị trí đỗ xe không tồn tại');
        }

        final ticketRef = storage.collection('vehicles').doc(ticket.id);
        final ticketDoc = await transaction.get(ticketRef);
        if (!ticketDoc.exists) {
          throw Exception('Không tìm thế thẻ xe');
        }

        transaction.update(lotRef, {
          'status': ParkingLotStatus.occupiedKnown.toJson(),
          'vehicleLicensePlate': ticket.vehicleLicensePlate,
          'ticketId': ticket.id,
          'timeIn': FieldValue.serverTimestamp(),
        });

        transaction.update(ticketRef, {
          'parkingFloor': lot.floor,
          'parkingLotId': lot.id,
          'parkingLotName': lot.name,
        });

        return lot;
      });
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }

  @override
  Future<void> outParking(ParkingLot lot) async {
    // update parking lot status, vehicleLicensePlate, and ticketId
    try {
      await storage.runTransaction((transaction) async {
        final lotRef = storage.collection(parking).doc(lot.id);
        final lotDoc = await transaction.get(lotRef);
        if (!lotDoc.exists) {
          throw Exception('Vị trí đỗ xe không tồn tại');
        }

        final ticketRef = storage.collection('vehicles').doc(lot.ticketId);
        final ticketDoc = await transaction.get(ticketRef);
        if (!ticketDoc.exists) {
          throw Exception('Không tìm thế thẻ xe');
        }

        transaction.update(lotRef, {
          'status': ParkingLotStatus.available.toJson(),
          'vehicleLicensePlate': null,
          'ticketId': null,
          'timeOut': FieldValue.serverTimestamp(),
        });

        transaction.update(ticketRef, {
          'parkingFloor': null,
          'parkingLotId': null,
          'parkingLotName': null,
        });
      });
    } catch (e) {
      logger.e(e);
      throw e;
    }
  }
}
