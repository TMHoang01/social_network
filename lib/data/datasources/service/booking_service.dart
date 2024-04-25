import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/utils/firebase.dart';

abstract class BookingServiceRemoteDataSource {
  Future<BookingService?> add({required BookingService booking});
  Future<void> update({required BookingService booking});
  Future<void> delete({required String id});

  Stream<List<BookingService>> getAll();
}

class BookingServiceRemoteDataSourceImpl
    implements BookingServiceRemoteDataSource {
  final colection = orderRef;
  @override
  Future<BookingService?> add({required BookingService booking}) async {
    try {
      final response = await colection.add(booking.toJson());
      return booking.copyWith(id: response.id);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Stream<List<BookingService>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<void> update({required BookingService booking}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
