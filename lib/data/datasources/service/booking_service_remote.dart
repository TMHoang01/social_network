import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/utils/firebase.dart';

abstract class BookingServiceRemoteDataSource {
  Future<BookingService?> add({required BookingService booking});
  Future<void> update({required BookingService booking});
  Future<void> delete({required String id});

  Stream<List<BookingService>> getAll();

  Future<List<BookingService>> getScheduleInDay(String date);
}

class BookingServiceRemoteDataSourceImpl
    implements BookingServiceRemoteDataSource {
  final colection = orderRef;
  @override
  Future<BookingService?> add({required BookingService booking}) async {
    try {
      final createAt = FieldValue.serverTimestamp();
      final json = booking.toJson();
      json['createdAt'] = createAt;
      final response = await colection.add(json);
      return booking.copyWith(id: response.id);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<BookingService>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<void> update({required BookingService booking}) {
    // TODO: implement update
    throw UnimplementedError();
  }

  @override
  Future<List<BookingService>> getScheduleInDay(String date) async {
    // flitter array scheduleDates date >= date && date < nextDay
    try {
      final firestore = FirebaseFirestore.instance;
      final response = await firestore
          .collection("orders")
          .where("scheduleBooking.scheduleDates", arrayContains: date)
          .get();
      final list = response.docs
          .map((e) => BookingService.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      return list;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }
}
