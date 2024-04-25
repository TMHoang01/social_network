import 'package:social_network/data/datasources/service/booking_service.dart';
import 'package:social_network/domain/models/service/booking_service.dart';
import 'package:social_network/domain/models/service/enum_service.dart';

abstract class BookingRepository {
  Future<BookingService?> add({required BookingService bookingService});
  Future<void> updateStatus(
      {required String id, required BookingStatus status});
  Future<void> delete({required String id});
  Stream<List<BookingService>> getAllByUserId({required String userId});
  Stream<List<BookingService>> getAll();

  Future<List<BookingService>> getSchedule(DateTime date) {}
}

class BookingRepositoryIml implements BookingRepository {
  final BookingServiceRemoteDataSource remoteDate;

  BookingRepositoryIml(this.remoteDate);

  @override
  Future<BookingService?> add({required BookingService bookingService}) {
    return remoteDate.add(booking: bookingService);
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
  Stream<List<BookingService>> getAllByUserId({required String userId}) {
    // TODO: implement getAllByUserId
    throw UnimplementedError();
  }

  @override
  Future<void> updateStatus(
      {required String id, required BookingStatus status}) {
    // TODO: implement updateStatus
    throw UnimplementedError();
  }
}
