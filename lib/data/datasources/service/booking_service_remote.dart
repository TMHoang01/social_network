import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/schedule_booking.dart';
import 'package:social_network/domain/models/service/schedule_item.dart';
import 'package:social_network/sl.dart';
import 'package:social_network/utils/firebase.dart';
import 'package:social_network/utils/utils.dart';

abstract class BookingServiceRemoteDataSource {
  Future<BookingService?> add({required BookingService booking});
  Future<void> update({required BookingService booking});
  Future<void> delete({required String id});

  Future<List<BookingService>> getAll();

  Future<List<BookingService>> getScheduleInDay(String date);

  Future<void> updateStatus(
      {required String id, required BookingStatus status});

  Future<List<BookingService>> getAllByUserId({required String userId});

  Future<void> acceptBooking({required BookingService booking});
}

class BookingServiceRemoteDataSourceImpl
    implements BookingServiceRemoteDataSource {
  final db = sl<FirebaseFirestore>();
  late final ordersRef = db.collection('orders');
  @override
  Future<BookingService?> add({required BookingService booking}) async {
    try {
      final createAt = FieldValue.serverTimestamp();
      final json = booking.toJson();
      json['createdAt'] = createAt;
      final response = await ordersRef.add(json);
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
  Future<List<BookingService>> getAll() async {
    try {
      final response =
          await ordersRef.orderBy('createdAt', descending: true).get();
      final list = response.docs
          .map((e) => BookingService.fromDocumentSnapshot(e))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
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
          .where("schedule.scheduleDates", arrayContains: date)
          //     .where("status", whereIn: [
          //   BookingStatus.accepted.toJson(),
          //   BookingStatus.completed.toJson()
          // ])
          .get();
      final list = response.docs
          .map((e) => BookingService.fromJson(e.data() as Map<String, dynamic>))
          .toList();

      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> updateStatus(
      {required String id, required BookingStatus status}) async {
    try {
      await ordersRef.doc(id).set({
        'status': status.toJson(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<BookingService>> getAllByUserId({required String userId}) async {
    try {
      final response = await ordersRef
          .where('createdBy', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      final list = response.docs
          .map((e) => BookingService.fromDocumentSnapshot(e))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> acceptBooking({required BookingService booking}) async {
    try {
      await db.runTransaction((transaction) async {
        final doc = db.collection('orders').doc(booking.id);

        final snapshot = await transaction.get(doc);
        if (!snapshot.exists) {
          throw Exception('Document does not exist!');
        }

        transaction.update(doc, {
          'status': BookingStatus.accepted.toJson(),
        });

        // Create schedules
        final schedule = booking.schedule;
        final scheduleDates = schedule?.scheduleDates;
        if (scheduleDates != null) {
          for (var element in scheduleDates) {
            ScheduleItem item =
                ScheduleItem.fromScheduleBooking(booking, element);
            transaction.set(
              db.collection('schedules').doc(),
              item.toJson(),
            );
          }
        }
      });
    } catch (e) {
      logger.e(e);
      throw Exception(e.toString());
    }
  }
}
