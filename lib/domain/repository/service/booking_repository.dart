import 'package:social_network/data/datasources/service/booking_service_remote.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';
import 'package:social_network/utils/utils.dart';

abstract class BookingRepository {
  Future<BookingService?> add({required BookingService bookingService});
  Future<void> updateStatus(
      {required String id, required BookingStatus status});
  Future<void> delete({required String id});
  Future<List<BookingService>> getAllByUserId({required String userId});
  Future<List<BookingService>> getAll();

  Future<List<BookingService>> getScheduleInDay(DateTime date);
}

class BookingRepositoryIml implements BookingRepository {
  final BookingServiceRemoteDataSource remoteDate;

  BookingRepositoryIml(this.remoteDate);

  @override
  Future<BookingService?> add({required BookingService bookingService}) async {
    return remoteDate.add(booking: bookingService);
  }

  @override
  Future<void> delete({required String id}) async {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<BookingService>> getAll() async {
    return await remoteDate.getAll();
  }

  @override
  Future<List<BookingService>> getAllByUserId({required String userId}) async {
    return await remoteDate.getAllByUserId(userId: userId);
  }

  @override
  Future<void> updateStatus(
      {required String id, required BookingStatus status}) async {
    return await remoteDate.updateStatus(id: id, status: status);
  }

  @override
  Future<List<BookingService>> getScheduleInDay(DateTime date) async {
    final string = TextFormat.formatDate(date);
    return await remoteDate.getScheduleInDay(string);
  }
}
