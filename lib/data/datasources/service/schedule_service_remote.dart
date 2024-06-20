import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/schedule_item.dart';
import 'package:social_network/utils/logger.dart';

abstract class ScheduleServiceRemoteDataSource {
  Future<ScheduleItem?> add({required ScheduleItem schedule});
  Future<void> update({required ScheduleItem schedule});
  Future<void> delete({required String id});

  Future<List<ScheduleItem>> getAll();
  Future<List<ScheduleItem>> getAllByUserId({required String userId});
  Future<List<ScheduleItem>> getAllByBookingId({required String bookingId});

  Future<List<ScheduleItem>> getScheduleInDay(String date);

  Future<void> updateStatus(
      {required String id, required ScheduleItemStatus status});

  Future<void> acceptSchedule({required ScheduleItem schedule});
}

class ScheduleServiceRemoteDataSourceImpl
    implements ScheduleServiceRemoteDataSource {
  final db = FirebaseFirestore.instance;
  late final scheduleRef = db.collection('schedules');
  @override
  Future<ScheduleItem?> add({required ScheduleItem schedule}) async {
    try {
      final createAt = FieldValue.serverTimestamp();
      final json = schedule.toJson();
      json['createdAt'] = createAt;
      final response = await scheduleRef.add(json);
      return schedule.copyWith(id: response.id);
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> delete({required String id}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleItem>> getAll() async {
    try {
      final response = await scheduleRef.orderBy('date').get();
      final list = response.docs
          .map((e) => ScheduleItem.fromDocumentSnapshot(e))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<List<ScheduleItem>> getScheduleInDay(String date) {
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleItem>> getAllByUserId({required String userId}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleItem>> getAllByBookingId(
      {required String bookingId}) async {
    try {
      final response = await scheduleRef
          .where('bookingId', isEqualTo: bookingId)
          .orderBy('date')
          .get();
      final list = response.docs
          .map((e) => ScheduleItem.fromDocumentSnapshot(e))
          .toList();
      return list;
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> update({required ScheduleItem schedule}) async {
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus(
      {required String id, required ScheduleItemStatus status}) async {
    try {
      await scheduleRef.doc(id).update({'status': status.toJson()});
    } on FirebaseException catch (e) {
      logger.e(e.toString());
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> acceptSchedule({required ScheduleItem schedule}) async {
    throw UnimplementedError();
  }
}
