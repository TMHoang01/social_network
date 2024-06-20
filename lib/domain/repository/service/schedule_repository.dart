import 'package:social_network/data/datasources/service/schedule_service_remote.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/domain/models/service/schedule_item.dart';

abstract class ScheduleServiceRepository {
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

class ScheduleServiceRepositoryImpl implements ScheduleServiceRepository {
  final ScheduleServiceRemoteDataSource remoteData;

  ScheduleServiceRepositoryImpl(this.remoteData);

  @override
  Future<ScheduleItem?> add({required ScheduleItem schedule}) async {
    return remoteData.add(schedule: schedule);
  }

  @override
  Future<void> delete({required String id}) async {
    throw UnimplementedError();
  }

  @override
  Future<List<ScheduleItem>> getAll() async {
    return await remoteData.getAll();
  }

  @override
  Future<List<ScheduleItem>> getAllByUserId({required String userId}) async {
    return await remoteData.getAllByUserId(userId: userId);
  }

  @override
  Future<void> acceptSchedule({required ScheduleItem schedule}) async {
    return await remoteData.acceptSchedule(schedule: schedule);
  }

  @override
  Future<List<ScheduleItem>> getAllByBookingId(
      {required String bookingId}) async {
    return await remoteData.getAllByBookingId(bookingId: bookingId);
  }

  @override
  Future<List<ScheduleItem>> getScheduleInDay(String date) async {
    return await remoteData.getScheduleInDay(date);
  }

  @override
  Future<void> updateStatus(
      {required String id, required ScheduleItemStatus status}) async {
    return await remoteData.updateStatus(id: id, status: status);
  }

  @override
  Future<void> update({required ScheduleItem schedule}) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
